From: Cedric Sodhi <ManDay@openmail.cc>
Subject: Re: SCSI Oops: Unable to handle kernel NULL ptr dereference
Date: Fri, 11 Aug 2017 09:35:10 +0200
Message-ID: <20170811073509.GC2729@air>
References: <20170810170537.Horde.8CxBesYMH_QVGbAB7dui6vz@www.vfemail.net>
 <1502402499.4120.133.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from onethreetwo.vfemail.net ([199.16.11.132]:20803 "EHLO
        vfemail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753281AbdHKNeJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 09:34:09 -0400
Content-Disposition: inline
In-Reply-To: <1502402499.4120.133.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

The following shows in dmesg when the USB side is plugged in:

usb 1-3: new high-speed USB device number 5 using xhci_hcd
usb 1-3: New USB device found, idVendor=174c, idProduct=55aa
usb 1-3: New USB device strings: Mfr=2, Product=3, SerialNumber=1
usb 1-3: Product: ASM1153 USB3.0 TO SATA
usb 1-3: Manufacturer: Liangteng
usb 1-3: SerialNumber: 1153201404001
usb-storage 1-3:1.0: USB Mass Storage device detected
usb-storage 1-3:1.0: Quirks match for vid 174c pid 55aa: 400000
scsi host3: usb-storage 1-3:1.0
scsi 3:0:0:0: Direct-Access     ASMT     2115             0    PQ: 0 ANSI: 6
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: [sdb] Spinning up disk...
ready
sd 3:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 3:0:0:0: [sdb] Attached SCSI disk

On Thu, Aug 10, 2017 at 06:01:39PM -0400, Ewan D. Milne wrote:
> [cc's snipped to linux-scsi ]
> 
> On Thu, 2017-08-10 at 17:05 +0000, manday@openmail.cc wrote:
> > Hello,
> > 
> > I'd like to report this rare panic I experienced today. I've been on  
> > 4.12.3 since it was released and got this panic totally unexpected,  
> > probably when terminating my WL compositor. I attach to this message a  
> > capture of the screen. The problem occurred never before and never  
> > after since, suggesting I will not be able to reproduce it easily.  
> > Perhaps it means something to someone.
> > 
> > Linux air 4.12.3 #4 SMP Fri Jul 28 12:07:06 CEST 2017 x86_64 Intel(R)  
> > Core(TM)i5-6267U CPU @ 2.90GHz GenuineIntel GNU/Linux
> > 
> > I don't know what additional information might be useful so if there  
> > is anything else I should provide please tell me.
> > 
> > Best regards,
> > Cedric
> 
> Your stack trace indicates some kind of corruption in a kmem cache
> used by the SCSI code, uncovered when the block queue was being freed.
> Can you describe what SCSI hardware is connected to your machine?
> A snippet of your boot messages showing the hardware probe would help.
> 
> -Ewan
> 
> 

-------------------------------------------------

ONLY AT VFEmail! - Use our Metadata Mitigator to keep your email out of the NSA's hands!
$24.95 ONETIME Lifetime accounts with Privacy Features!  
15GB disk! No bandwidth quotas!
Commercial and Bulk Mail Options!  
