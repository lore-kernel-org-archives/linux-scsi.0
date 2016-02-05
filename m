From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: Add Marvell Console to VPD blacklist
Date: Thu, 04 Feb 2016 22:36:19 -0500
Message-ID: <yq1io23g764.fsf@sermon.lab.mkp.net>
References: <1453904353-42756-1-git-send-email-mika.westerberg@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36609 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbcBEDg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 22:36:28 -0500
In-Reply-To: <1453904353-42756-1-git-send-email-mika.westerberg@linux.intel.com>
	(Mika Westerberg's message of "Wed, 27 Jan 2016 16:19:13 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Alexander Duyck <alexander.duyck@gmail.com>

>>>>> "Mika" == Mika Westerberg <mika.westerberg@linux.intel.com> writes:

Mika> I have a Marvell 88SE9230 SATA Controller that has some sort of
Mika> integrated console SCSI device attached to one of the ports.

Applied to 4.5/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
