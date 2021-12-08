package main

import (
	"fmt"
	"log"

	"github.com/ankitksh81/distributed-log/server"
)

func main() {
	server := server.NewHTTPServer(":8080")
	fmt.Println("Server running on port: 8080")
	log.Fatal(server.ListenAndServe())
}
