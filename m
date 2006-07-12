From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptsas: add parent port backlink
Date: Wed, 12 Jul 2006 15:23:16 -0400
Message-ID: <1152732196.4086.15.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701F667C@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61608 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750818AbWGLTXT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 15:23:19 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701F667C@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> On Wed, 2006-07-12 at 13:18 -0600, Moore, Eric wrote:
> I don't see where the backlink is create, so I'm not sure
> why this is needed.  Is the backlink in /sys/class/sas_port, 
> /sys/class/sas_device, or /sys/class_expander ?

It's created in the port directory of the device tree.

> Also, I noticed that in yesterdays patch to solve another
> issue with regarding mptsas integrated raid, you had slipped
> this backlink stuff in that patch.   That part was rejected
> when I applied that patch.  Just letting you know.

Apparently that was some type of quilt cockup ... not sure how ... I
probably did a git checkout in the middle of a quilt series.

That hunk is reverted from the patches I put into the rc-fixes tree.

James


