From: Srihari Vijayaraghavan <harisri@bigpond.com>
Subject: Fwd: Re: 2.5.65 and cciss
Date: Fri, 21 Mar 2003 11:38:20 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303211138.20973.harisri@bigpond.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from desktop ([144.135.24.72]) by mta07bw.email.bigpond.com
 (iPlanet Messaging Server 5.2 HotFix 1.09 (built Jan  7 2003))
 with SMTP id <0HC2003UMPTB1E@mta07bw.email.bigpond.com> for
 linux-scsi@vger.kernel.org; Fri, 21 Mar 2003 10:39:12 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: steve.cameron@hp.com
Cc: linux-scsi@vger.kernel.org

Sorry, it bounced back on the first attempt :(

----------  Forwarded Message  ----------

Subject: Re: 2.5.65 and cciss
Date: Fri, 21 Mar 2003 11:31:35 +1100
From: Srihari Vijayaraghavan <harisri@bigpond.com>
To: steve.cameron@hp.com
Cc: linux-scsi@vger.kernel.org

Steve,

On Thursday 20 March 2003 20:06, Stephen Cameron wrote:
> Yeah, I am using it.

That's good.

> Are you compiling cciss statically or as a module?

Statically. (since I don't have Rusty's modinit tools installed, everything
 is compiled in the kernel. No modules.

> If statically, are you using labels in your fstab?

Possibly. However there is a hard coded "root=/dev/cciss/c0d0p5" kernel boot
parameter passed on by /etc/grub.conf. How come /etc/fstab matters for
kernel? (actually /etc/fstab isn't accessible until at least root has been
mounted read-only, isn't it?)

However 2.4.21-pre5 is fine while /etc/fstab may be using "label" (ie, it
still boots fine with the root=/dev/cciss/c0d0p5 kernel boot parameter)

> In which case,
> you typically (e.g. redhat 8) MUST have an initrd image to get the right
> version of "mount" around that understands labels... (just a wild guess).
>
> Describe your configuration in more detail.

2 Xeon 2.8 GHz 512 KB L2
1 GB RAM
70 GB Hardware RAID-0 on SmartArray Controller 5i
Every file system is ext3 except out data fs which is ext2 (actually no ext2
fs involved in during boot)
RH 8.0 with upto date official updates (GCC 3.2.0 and glibc etc..)
2 Broadcom GigE onboard
4 Intel EEPRO or 4 Intel GigE cards
IDE CDROM
Floppy

I will be able to give .config on request.

Thanks.
--
Hari
harisri@bigpond.com

-------------------------------------------------------

-- 
Hari
harisri@bigpond.com


