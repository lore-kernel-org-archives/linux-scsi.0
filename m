From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3.13-rc3]  firewire: sbp2: bring back WRITE SAME support
Date: Tue, 17 Dec 2013 17:18:30 -0500
Message-ID: <yq1mwjz6s09.fsf@sermon.lab.mkp.net>
References: <20121125184525.0b7967c4@stein>
	<yq18v9nsz3q.fsf@sermon.lab.mkp.net> <20121202191654.59117ac2@stein>
	<20131215155238.6016b038@stein> <20131215164043.0e341695@stein>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29996 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3LQWSu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 17:18:50 -0500
In-Reply-To: <20131215164043.0e341695@stein> (Stefan Richter's message of
	"Sun, 15 Dec 2013 16:40:43 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> Commit 54b2b50c20a6 "[SCSI] Disable WRITE SAME for RAID and
Stefan> virtual host adapter drivers" disabled WRITE SAME support for
Stefan> all SBP-2 attached targets.  But as described in the changelog
Stefan> of commit b0ea5f19d3d8 "firewire: sbp2: allow WRITE SAME and
Stefan> REPORT SUPPORTED OPERATION CODES", it is not required to
Stefan> blacklist WRITE SAME.

Stefan> Bring the feature back by reverting the sbp2.c hunk of commit
Stefan> 54b2b50c20a6.

That's entirely your call and perfectly fine by me.

I just get a lot of complaints about "WRITE SAME failed. Manually
zeroing". But I guess I can only blame myself for not making it clear
that that's a warning and not an error...

-- 
Martin K. Petersen	Oracle Linux Engineering
