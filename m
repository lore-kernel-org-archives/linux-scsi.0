From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: new kernel = megaraid performance cut in half
Date: Tue, 14 May 2002 10:30:18 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E177YdO-0007VV-00@the-village.bc.nu>
References: <3CE0D359.9070800@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CE0D359.9070800@aptalaska.net> from "Matthew Schumacher" at May 14, 2002 01:05:29 AM
List-Id: linux-scsi@vger.kernel.org
To: Matthew Schumacher <matt.s@aptalaska.net>
Cc: linux-scsi@vger.kernel.org

> I am running exactly 1g of ram in the machine.  Is there a way to apply 
> those patches manually or should I get the kernel-2.4.18-4.i686.rpm from 
> here: http://rhn.redhat.com/errata/RHBA-2002-085.html.

Your best bet is probably to grab the RH errata kernel. If you get the
source rpm that also includes the patches for some controllers to do
I/O from all of memory.

Hopefully that restores the speed
