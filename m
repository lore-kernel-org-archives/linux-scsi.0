From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: new kernel = megaraid performance cut in half
Date: Tue, 14 May 2002 10:21:18 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E177YUg-0007Tf-00@the-village.bc.nu>
References: <3CE0D0F4.3000601@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CE0D0F4.3000601@aptalaska.net> from "Matthew Schumacher" at May 14, 2002 12:55:16 AM
List-Id: linux-scsi@vger.kernel.org
To: Matthew Schumacher <matt.s@aptalaska.net>
Cc: linux-scsi@vger.kernel.org

> running redhat 7.2.  I was using the default kernel but I decided to 
> upgrade to 2.4.18 to get the new VM code and for some quota fixes. 
> Anyway, I compiled the kernel and the machine boots fine but my disk 
> speed cut in half.

Do you have large amounts of memory ? The Red Hat kernel includes patches
that vastly up performance of DMA capable controllers when more than 1Gb
of RAM is in use.

Alan
