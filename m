From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached PHYs)
Date: Sat, 22 Oct 2005 09:51:17 -0700 (PDT)
Message-ID: <20051022165117.95751.qmail@web31803.mail.mud.yahoo.com>
References: <4359A9FE.4010503@pobox.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:36795 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750714AbVJVQvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 12:51:18 -0400
In-Reply-To: <4359A9FE.4010503@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, dougg@torque.net
Cc: Matthew Wilcox <matthew@wil.cx>, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, andrew.patterson@hp.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

--- Jeff Garzik <jgarzik@pobox.com> wrote:
> Invalid example.  All of the methods listed -- request_queue, netlink, 
> chrdev, sysfs, ioctl -- will work just fine when the root filesystem is 
> on the far side of a SAS expander.  These are just methods of 
> communication, nothing more.

Jeff, why don't you listen from time to time to people who work with
the technology on a daily basis who have experience with it, who
have _insight_ of the technology?  Such insight gives them great
intuition when it comes to design, among other things.

> In your example -- userspace discovery required before root filesystem 
> can be found -- a program running from initrd/initramfs would create an 
> SMP device node, open it, and then proceed with the discovery and 

SMP is part of the protocol, of what the device (PCI) implements.  It is always
there, just like phys.  You do not need to create it from user space. It
will be there for a user process to use, via say SDI.  SDI provides this as
part of the controller.  Read the SDI spec.

Insight of the whole architecture is irreplacable to create good design.

> configuration process, which in turn creates the device nodes necessary 
> to mount the root filesystem.

Also note that everyone does domain discovery in the kernel/FW and not
only for SAS but for other domains (even non-SCSI).  While domain
discovery is in the kernel/FW, _control_ of the domain is given to
user space, via say SDI -- everyone agrees on this.

   Luben

