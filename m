From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [BKPATCH] Updated qla2xxx driver against scsi-misc-2.6.
Date: Fri, 30 Jan 2004 11:25:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EE01@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:51247 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263561AbUA3TZ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 14:25:27 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Friday, January 30, 2004 10:11 AM, James Bottomley wrote:
> On Fri, 2004-01-30 at 11:59, Andrew Vasquez wrote:
> > I'm still trying to get the hang of using BK, so I hope sending
> > updates in this way will be suitable.
> 
> Actually, not against my scsi-misc-2.6 tree, no.  The reason is that I
> frequently take apart and rebuild that tree as the patch composition
> changes (I did it only a day ago to pull out your initial SNS
> patch and
> put the new one in).
> 
> BK is very fussy about having all changesets in a tree to do a bk
> receive on.  However, as I pull apart the tree BK cannot import it
> because the bkpatch now depends on missing changesets.
> 
> Using the tree internally to generate a real patch is fine, but I
> frequently can't import bk patches against it.
> 

Ok, thanks for clearing that up.  I'll stick to patches against 
scsi-misc-2.6.

> > Here's the list of changes (1.1533 -> 1.1539) and a patch (1.1534 ->
> > 1.1539 -- minus the firmware file diffs [to reduce the noise]) for
> > review. 
> 
> I've successfully applied the diff in your email and added the history
> to the single change set comment, thanks.
>

Good.  Then could you add the final piece (firmware updates) to your
tree?  I've uploaded a bzip'd diff to add the 3.02.21 firmware for the
ISPs at SF.net:

	http://osdn.dl.sourceforge.net/sourceforge/linux-qla2xxx/qla2xxx_fw_update-v2.6.diff.bz2

Here's the changelog once more:

	# The following is the BitKeeper ChangeSet Log
	# --------------------------------------------
	# 04/01/30	andrew.vasquez@apc.qlogic.com	1.1534
	# Resync with latest released firmware 3.02.21.
	# --------------------------------------------

Thanks again,
Andrew Vasquez
