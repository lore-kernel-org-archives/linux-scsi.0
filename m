From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] ncr5380: Exception handling fixes for v4.5
Date: Mon, 29 Feb 2016 21:31:51 -0500
Message-ID: <yq1d1rfc4iw.fsf@sermon.lab.mkp.net>
References: <20160222230703.994951661@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25114 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbcCACcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 21:32:05 -0500
In-Reply-To: <20160222230703.994951661@telegraphics.com.au> (Finn Thain's
	message of "Tue, 23 Feb 2016 10:07:03 +1100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn> These patches fix some exception handling and autosense bugs that
Finn> I accidentally introduced in v4.5-rc1.

Finn> drivers/scsi/NCR5380.c       |  133 +++++++++++++++++++------------------------
Finn> drivers/scsi/atari_NCR5380.c |  133 +++++++++++++++++++------------------------
Finn> 2 files changed, 118 insertions(+), 148 deletions(-)

This is a pretty big lump of changes for a 4.5 bug fix!

Given the limited exposure based on the nature of the affected hardware
I have queued them for 4.6.

-- 
Martin K. Petersen	Oracle Linux Engineering
