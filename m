From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Tue, 5 Nov 2002 04:20:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211051220.EAA26599@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

	Oops, I see that Chrisoph Hellwig posted a patch 19.5 earlier
than mine that did this clean up and some other related ones, so please
disregard my patch and apply Christoph's.

	Chistoph, since you're in the process of doing similar
clean-ups, you might want to try my untested patch that eliminated
Scsi_Host_Name:

	 http://marc.theaimsgroup.com/?l=linux-scsi&m=103643303212376&w=2

	If it works and looks OK to you, Christoph, I'd encourage you
to put it into your patch stream if you want, so as to reduce patch
conflicts for James, Linus, et al.  On the other hand, if that just
creates work for you that you weren't keen on doing, don't worry about
it.  I don't mean to impose.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
