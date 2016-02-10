From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Fix for IO failing post OCR in SRIOV environment
Date: Tue, 09 Feb 2016 20:48:55 -0500
Message-ID: <yq1y4atbaig.fsf@sermon.lab.mkp.net>
References: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
	<1453995866-25097-2-git-send-email-sumit.saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29868 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbcBJBtf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 20:49:35 -0500
In-Reply-To: <1453995866-25097-2-git-send-email-sumit.saxena@avagotech.com>
	(Sumit Saxena's message of "Thu, 28 Jan 2016 21:14:25 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, Uday Lingala <uday.lingala@avagotech.com>

>>>>> "Sumit" == Sumit Saxena <sumit.saxena@avagotech.com> writes:

Sumit> Driver assumes that VFs always have peers present whenever they
Sumit> have same LD IDs. But this is not the case.  This patch handles
Sumit> the above mentioned by explicitly checking for a peer before
Sumit> making HA/non-HA path decision.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
