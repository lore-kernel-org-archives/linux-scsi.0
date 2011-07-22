From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 0/3] Persistent device name using alias name
Date: Fri, 22 Jul 2011 06:32:09 -0700
Message-ID: <20110722133209.GA9522@kroah.com>
References: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, coughlan@redhat.com, kzak@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, joe@perches.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2011 at 07:59:26PM +0900, Nao Nishijima wrote:
> Hi,
> 
> This patch series provide an "alias name" of the disk into kernel messages.
> Users can assign a preferred name to an alias name of the device.
> 
> A raw device name of a disk does not always point a same disk at each boot-up
> time. Therefore, users have to use persistent device names, which udev creates
> to always access the same disk. However, kernel messages still display the raw
> device names.
> 
> My proposal is that users can use and see persistent device names which were
> assigned by they because users expect same name to point same disk anytime.
> 
> Why need to modify kernel messages?
> - We can see mapping of device names and persistent device names in udev log.
>   If those logs output to syslog, we can search persistent device name from
>   device name, but it can cause a large amount of syslog output.
> 
> - If we can use the persistent device names and can always see the same name on
>   the kernel log, we don't need to pay additional cost for searching and picking
>   a correct pair of device name and persistent device name from udev log.
> 
> - Kernel messages are output to serial console when kenel crashes,
>   it's so hard to convert device name to alias name.
> 
> 
> Of course, I am going to modify the commands using device name so that users
> can use alias names.

Please do that first, and then you will not need any kernel changes in
the first place :)

Anyway, you all know my objections to this patch series, but again, as
I'm not the block subsystem maintainer, I really can't do anything.

greg k-h
