package main

import (
	"bufio"
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"time"
)

func readLastLines(filename string, n int) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
		if len(lines) > n {
			lines = lines[1:]
		}
	}
	return lines, scanner.Err()
}

func writeLogs(basePath, site string) {
	// Aikaleima hakemiston nimessä
	timeStamp := time.Now().Format("2006-01-02-15-04")
	logPath := fmt.Sprintf("%s/%s-%s/", basePath, timeStamp, site)

	// Luo hakemisto
	if err := os.MkdirAll(logPath, 0755); err != nil {
		fmt.Println("Hakemiston luonti epäonnistui:", err)
		return
	}

	// Määritellään lokitiedostot ja niiden nimet
	logFiles := map[string]string{
		"/var/log/ispconfig/httpd/siteby.fi/error.log":   "error.log",
		"/var/log/ispconfig/httpd/siteby.fi/access.log":  "access.log",
		"/var/log/messages":                              "messages.log",
	}

	for path, name := range logFiles {
		lines, err := readLastLines(path, 20)
		if err != nil {
			fmt.Println("Lokin lukeminen epäonnistui:", err)
			continue
		}
		content := []byte(fmt.Sprintf("%s\n", lines))
		ioutil.WriteFile(logPath+name, content, 0644)
	}
}

// restartApache yrittää käynnistää Apache-palvelimen uudelleen.
func restartApache() {
	fmt.Println("Yritetään käynnistää Apache-palvelin uudelleen...")
	cmd := exec.Command("/etc/init.d/apache2", "restart")
	if err := cmd.Run(); err != nil {
		fmt.Println("Apache-palvelimen uudelleenkäynnistys epäonnistui:", err)
	} else {
		fmt.Println("Apache-palvelimen uudelleenkäynnistys onnistui.")
	}
}

// checkSite tarkistaa sivuston toimivuuden.
func checkSite(url string) {
	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: false},
		},
	}

	response, err := client.Get(url)
	if err != nil || response.StatusCode != 200 {
		fmt.Println("Yhteys epäonnistui, kirjoitetaan lokit ja yritetään käynnistää Apache uudelleen...")
		writeLogs("/var/log/checksite/", "siteby.fi")
		restartApache()
		return
	}
	defer response.Body.Close()
	fmt.Println("ei ongelmia")
}

func main() {
	for {
		checkSite("https://siteby.fi")
		time.Sleep(120 * time.Second) 
	}
}
