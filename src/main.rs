use std::net::{Shutdown, TcpListener};
use std::thread;
use std::io::Write;
 
const RESPONSE: &'static [u8] = b"HTTP/1.1 200 OK\r
Content-Type: application/json; charset=UTF-8\r\n\r
{\"message\":\"Go EC2! your request was processed!\"}
\r";
 
 
fn main() {
    let listener = TcpListener::bind("0.0.0.0:8080").unwrap();
 
    for stream in listener.incoming() {
        thread::spawn(move || {
            let mut stream = stream.unwrap();
            match stream.write(RESPONSE) {
                Ok(_) => println!("Response sent!"),
                Err(e) => println!("Failed sending response: {}!", e),
            }
            stream.shutdown(Shutdown::Write).unwrap();
        });
    }
}