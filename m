From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Patch for 256 disks in 2.4
Date: Mon, 22 Jul 2002 21:57:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3566.42994233898$1027371630@news.gmane.org>
References: <20020720195729.C20953@devserv.devel.redhat.com> <20020722170840.GB19587@nbkurt.etpnet.phys.tue.nl> <20020722164856.D19904@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020722164856.D19904@devserv.devel.redhat.com>; from zaitcev@redhat.com on Mon, Jul 22, 2002 at 04:48:56PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Mon, Jul 22, 2002 at 04:48:56PM -0400, Pete Zaitcev wrote:
> > I've written a patch for sd that makes the allocation of majors
> > dynamic. The driver just takes 8 at sd_init and further majors are 
> > allocated when disks are attached. Which saves a lot of memory for
> > all the gendisk and hd_struct stuff in case you do not have a lot of 
> > SCSI disks connected. The patch does support up to 160 SD majors, 
> > though currently, it won't succeed getting more than 132 majors.
> 
> That's wonderful, but we cannot ship that. There is no userland
> support to create device nodes in dynamic fashion and to ensure
> that they do not conflict. This is why Arjan filed for and received
> additional majors. Dynamic solutions need some time to float about
> the community, I think.

I might be stupid, but it looks to me like we want both the new majors
and the kernel structs dynamically allocated when they get actually used..

