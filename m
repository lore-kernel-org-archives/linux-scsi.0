From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: new kernel = megaraid performance cut in half
Date: Tue, 14 May 2002 11:43:27 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E177ZmB-0007dW-00@the-village.bc.nu>
References: <3CE0DD7B.9090201@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CE0DD7B.9090201@aptalaska.net> from "Matthew Schumacher" at May 14, 2002 01:48:43 AM
List-Id: linux-scsi@vger.kernel.org
To: Matthew Schumacher <matt.s@aptalaska.net>
Cc: linux-scsi@vger.kernel.org

>   Timing buffered disk reads:  64 MB in  1.22 seconds = 52.46 MB/sec
> [root@mail_test root]# hdparm -t /dev/sda
> 
> So the redhat 2.4.18 kernel reads disk almost 2.5 times better on my 
> system.... sounds like something that would be handy in a stable kernel 
> release.

Agreed, however thats something that really has to be post 2.4.19 so it
gets a lot of testing when merged with the base tree to make sure it has
no dependancies on other changes
