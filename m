From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 08:35:23 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4148370B.4070704@rtr.ca>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com> <1095186343.2008.29.camel@mulgrave> <4147AB5A.4060804@rtr.ca> <20040915024720.GA23694@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20040915024720.GA23694@havoc.gtf.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lsml@rtr.ca>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

I would really like to work on consolidating the ATA code in libata,
though.  As the name implies, it's a library -- don't feel that your
driver must conform to the libata driver API in order to make use of all
its functions.  And feel free to add to it.

Yes, there are definite code sharing possibilities there to be explored.
Right now, my first priority is to get support for this hardware
into the kernel.  This same driver source will also be backported
to mid-2.4.xx series, both Redhat and generic.

After that, we can modify some interfaces to reduce the small overlaps
that may present.

Next revision is due out later today.  It may still have a few warts
to work out, but I think it is looking much better than before.

Better to have a decent hardware driver within the tree,
than an unknown vendor-only binary driver outside the tree.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
