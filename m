From: Srihari Vijayaraghavan <harisri@bigpond.com>
Subject: Re: 2.5.65 and cciss
Date: Fri, 21 Mar 2003 11:31:35 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303211131.35221.harisri@bigpond.com>
References: <20030320090625.GA32689@zuul.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030320090625.GA32689@zuul.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: steve.cameron@hp.com
Cc: linux-scsi@vger.kernel.org

Steve,

On Thursday 20 March 2003 20:06, Stephen Cameron wrote:
> Yeah, I am using it.

That's good.

> Are you compiling cciss statically or as a module?

Statically. (since I don't have Rusty's modinit tools installed, everything is 
compiled in the kernel. No modules.

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

