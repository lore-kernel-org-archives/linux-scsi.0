From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [BKPATCH] Updated qla2xxx driver against scsi-misc-2.6.
Date: 30 Jan 2004 13:11:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075486284.2026.47.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B060EDFF@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:41647 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262746AbUA3SLc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 13:11:32 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EDFF@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-01-30 at 11:59, Andrew Vasquez wrote:
> The bksend patch can be downloaded from the SF.net site:
> 
> 	http://prdownloads.sourceforge.net/linux-qla2xxx/qla2xxx-v2.6-20040130.bksend.bz2
> 
> I'm still trying to get the hang of using BK, so I hope sending updates
> in this way will be suitable.

Actually, not against my scsi-misc-2.6 tree, no.  The reason is that I
frequently take apart and rebuild that tree as the patch composition
changes (I did it only a day ago to pull out your initial SNS patch and
put the new one in).

BK is very fussy about having all changesets in a tree to do a bk
receive on.  However, as I pull apart the tree BK cannot import it
because the bkpatch now depends on missing changesets.

Using the tree internally to generate a real patch is fine, but I
frequently can't import bk patches against it.

> Here's the list of changes (1.1533 -> 1.1539) and a patch (1.1534 -> 
> 1.1539 -- minus the firmware file diffs [to reduce the noise]) for review.

I've successfully applied the diff in your email and added the history
to the single change set comment, thanks.

James


