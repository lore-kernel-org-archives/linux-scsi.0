From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [garloff@suse.de: Re: [linux-usb-devel] Re: /proc/scsi/map]
Date: Mon, 17 Jun 2002 09:29:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206171429.g5HETBV02481@localhost.localdomain>
References: <kurt@garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA22626
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2002 07:29:29 -0700
In-Reply-To: Message from Kurt Garloff <kurt@garloff.de>
   of "Mon, 17 Jun 2002 03:24:00 +0200." <20020617012400.GH21461@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <kurt@garloff.de>, Oliver Neukum <oliver@neukum.name>, dougg@torque.net, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net

kurt@garloff.de said:
> This may work for your disks. You just can't open the device node for
> a tape, if there is no medium inserted. If you know the mapping
> between to a sg device you can use it.

Actually, you have to use sg for a disc as well since you send a scsi CDB 
directly to the device for inquiry page 0x83.

> That's the second piece of information that /proc/scsi/map provides. 

Oh no question.  The way the current code doing this works is that it opens 
all scsi devices and issues a GET_IDLUN to compile a database of the nodes and 
then matches them up to sg nodes.

James


