From: Samuel Flory <sflory@rackable.com>
Subject: Re: libata update posted (was Re: VIA Serial ATA chipset)
Date: Fri, 29 Aug 2003 10:21:43 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F4F8BA7.1080002@rackable.com>
References: <20030813074535.C3AB427AC8@mail.medav.de> <3F4F6863.4080400@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3F4F6863.4080400@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:

>
> So, here are the 2.4 and 2.6 versions of the VIA SATA support for 
> libata, contained in the latest libata update.
>
> 2.4 BK: bk://kernel.bkbits.net/jgarzik/atascsi-2.4
> 2.4 Patch: 
> ftp://ftp.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.4/2.4.23-pre1-libata3.patch.bz2 
>
>
> 2.6 BK: bk://kernel.bkbits.net/jgarzik/atascsi-2.6
> 2.6 Patch: 
> ftp://ftp.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.6/2.6.0-test4-bk2-libata3.patch.bz2 
>
>
>
> Changes:
> * add VIA SATA driver
> * fixes to software reset.
> * other fixes
> * split scsi-related code into separate file, libata-scsi.c.
> * continue work on phy layer
> * continue work towards fully async taskfile API:  you call 
> submit_tf(), and later on, your callback is called when the taskfile 
> completes or times out.   async taskfile API is required for ATAPI and 
> supporting more advanced host controllers like Promise or AHCI (SATA2).
> * some cleanups
>
>  
>

   I'm guessing there is no support for Promise yet? 

  I'm just asking because I've got this dual amd64 with 4 Promise sata 
ports.  Which for some reason there aren't drivers any 64 bit OS;-(


PS-  The driver works great on the silcon image chipset.  (Once I 
realized that my Seagate drive needed newer firmware.)

-- 
Once you have their hardware. Never give it back.
(The First Rule of Hardware Acquisition)
Sam Flory  <sflory@rackable.com>
