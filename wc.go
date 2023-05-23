package main

import "fmt"
import "flag"
import "os"
import "io"
import "log"
import "regexp"
import "strings"
import "unicode/utf8"

func main() {
	var c = flag.Bool("c", false, "count bytes")
	var l = flag.Bool("l", false, "count lines")
	var m = flag.Bool("m", false, "count chars")
	var w = flag.Bool("w", false, "count words")
	flag.Parse()

	if *m {
		*c = false
	}

	if !*c && !*l && !*m && !*w {
		*c = true
		*l = true
		*w = true
	}

	var contents []byte
	var err error
	filename := ""
	if flag.NArg() > 0 {
		filename = flag.Arg(0)
		contents, err = os.ReadFile(filename)
	} else {
		contents, err = io.ReadAll(os.Stdin)
	}

	if err != nil {
		log.Panic(err)
	}

	result := make([]int, 0, 3)
	text := ""

	if *l || *w || *m {
		text = string(contents)
	}

	if *l {
		trimmed := strings.TrimRight(text, "\n")
		result = append(result, len(regexp.MustCompile("\r?\n").Split(trimmed, -1)))
	}

	if *w {
		result = append(result, len(strings.Fields(text)))
	}

	if *c {
		result = append(result, len(contents))
	}

	if *m {
		result = append(result, utf8.RuneCountInString(text))
	}

	fmt.Println("\t", strings.Trim(strings.Join(strings.Fields(fmt.Sprint(result)), "\t"), "[]"), filename)
}
