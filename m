From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] megaraid_sas: Fix SMAP issue
Date: Tue, 09 Feb 2016 20:49:24 -0500
Message-ID: <yq1twlhbahn.fsf@sermon.lab.mkp.net>
References: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
	<1453995866-25097-3-git-send-email-sumit.saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24995 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbcBJBt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 20:49:56 -0500
In-Reply-To: <1453995866-25097-3-git-send-email-sumit.saxena@avagotech.com>
	(Sumit Saxena's message of "Thu, 28 Jan 2016 21:14:26 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

>>>>> "Sumit" == Sumit Saxena <sumit.saxena@avagotech.com> writes:

Sumit> Inside compat IOCTL hook of driver, driver was using wrong
Sumit> address of ioc-> frame.raw which leads sense_ioc_ptr to be
Sumit> calculated wrongly and failing IOCTL.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
