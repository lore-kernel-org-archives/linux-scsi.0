From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Sun, 5 Dec 2010 13:01:59 -0700
Message-ID: <201012051301.59223.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <201012040844.47337.thomas@fjellstrom.ca> <201012051008390934167@usish.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201012051008390934167@usish.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jack_wang <jack_wang@usish.com>
Cc: David Milburn <dmilburn@redhat.com>, Andre Tomt <andre@tomt.net>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On December 4, 2010, jack_wang wrote:
> On December 4, 2010, Thomas Fjellstrom wrote:
> > On December 4, 2010, Thomas Fjellstrom wrote:
> > > On December 4, 2010, jack_wang wrote:
> > > > 
> [snip]
> > 
> > Even after the reboot it still happens, though with that change, it 
/seems/
> > as if the pause is gone, but I can't be sure yet.
> > 
> Nope, pauses are still here, but they are shorter.
> 
> [Jack] Yes , once the host enter error handle , the scsi core will hold on 
the host(not sen IOs to the host as you see pause utill 
>  the error are corrected). The main reason of the host go into error host is 
there are commands have no response utill the command
> timer timeout, this maybe the disks need more time or the host lost interupt 
or some other reason.  You may need to change disks
> and host part by part to see what cause the command timeout.
> 

Well so far I see errors from 4 of my 6 disks since I rebooted 30 hours ago. 
And in the past I've seen these errors come from all disks. I'm more inclined 
to believe its some kind of handling issue than that all of those drives are 
in some way bad. Especially since that older driver I got from Andy Yan did 
not suffer from any of these issues. Of course it had other problems, like 
hotswap oopsing the kernel, but I almost never use hotswap, so it was never an 
issue for me.

Now I'm not sure its related, but I do see this:
[  342.353646] hrtimer: interrupt took 61135 ns
in my dmesg. But that really isn't that long of a pause least not by human 
standards. And theres only the one. It happens once just after boot up, and 
then never again (I assume because at bootup the machine is starting up 4 kvm 
VMs /at the same time/).

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
