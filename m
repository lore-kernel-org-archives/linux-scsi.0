From: Stephen Cameron <steve.cameron@hp.com>
Subject: Re: 2.5.65 and cciss
Date: Fri, 21 Mar 2003 08:47:43 +0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321024743.GA2267@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: harisri@bigpond.com
Cc: linux-scsi@vger.kernel.org


harisri@bigpond.com wrote:
> On Thursday 20 March 2003 20:06, Stephen Cameron wrote:
> > Yeah, I am using it.
> 
[...]
> Possibly. However there is a hard coded "root=/dev/cciss/c0d0p5" kernel boot
> parameter passed on by /etc/grub.conf. How come /etc/fstab matters for
> kernel? (actually /etc/fstab isn't accessible until at least root has been
> mounted read-only, isn't it?)

True enough. I guess I meant the "root=" in grub, as you point out, 
which doesn't use labels in your case.
> 
> > Describe your configuration in more detail.
> 
> 2 Xeon 2.8 GHz 512 KB L2
> 1 GB RAM
> 70 GB Hardware RAID-0 on SmartArray Controller 5i
> Every file system is ext3 except out data fs which is ext2 (actually no ext2
> fs involved in during boot)
> RH 8.0 with upto date official updates (GCC 3.2.0 and glibc etc..)
> 2 Broadcom GigE onboard
> 4 Intel EEPRO or 4 Intel GigE cards
> IDE CDROM
> Floppy
> 
> I will be able to give .config on request.
> 

Ok, .config would help to duplicate the problem.  
Also, console output (dmesg output) if it's not
too inconvenient.  (you might have to hook up a 
serial console to capture it.)

-- steve

