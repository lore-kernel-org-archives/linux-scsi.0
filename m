From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Re: Problem with megaraid-2.20.2.0 on Fedora Core 2
Date: 19 Aug 2004 12:30:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5gzn4rnlhx.fsf@patl=users.sf.net>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC97D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:6674 "HELO mail-ext.curl.com")
	by vger.kernel.org with SMTP id S266678AbUHSQa6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 12:30:58 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC97D@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

"Mukker, Atul" <Atulm@lsil.com> writes:

> megaraid_mbox now has a dependency on the megaraid_mm module. You
> need to make that also a part of the initrd image. Also, did you
> remember to run depmod?

Yes, I ran depmod, and Red Hat's "mkinitrd" script correctly picked up
the megaraid_mm dependency.

I have now edited /linuxrc on the initrd to remove the default
"setquiet" invocation, so it actually prints out what it is doing.  So
now when I boot, I see:

    Red Hat nash verison 3.5.22 starting
    Mounted /proc filesystem
    Mounting sysfs
    Loading scsi_mod.ko module
    Loading sd_mod.ko module
    Loading megaraid_mm.ko module
    Loading megaraid_mbox.ko module
    <NULL>: can_queue = 0 no longer supported
    Loading jbd.ko module
    Loading ext3.ko module
    Creating block devices
    kernel panic: VFS: Unable to mount root ...

I also tried inserting "sleep 3" before each invocation of insmod,
with the same results.

As you can see, I am definitely loading the megaraid_mm.ko module.

Am I loading these modules in the correct order?

Do you have any other suggestions?

Thanks!

 - Pat
