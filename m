From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 17/20 v1] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API instead of create_singlethread_workqueue() API
Date: Fri, 19 Jun 2015 16:46:13 -0400
Message-ID: <yq1fv5na0kq.fsf@sermon.lab.mkp.net>
References: <1434433027-40682-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22010 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbbFSUqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 16:46:49 -0400
In-Reply-To: <1434433027-40682-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 16 Jun 2015 11:07:07 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de, joe.lawrence@stratus.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> Created a thread using alloc_ordered_workqueue() API in order to
> process the works from firmware Work-queue sequentially instead of
> create_singlethread_workqueue() API.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
