From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] block: Fix integrity verification
Date: Tue, 08 Apr 2014 23:40:49 -0400
Message-ID: <yq1r457tbjy.fsf@sermon.lab.mkp.net>
References: <1397011424-10970-1-git-send-email-martin.petersen@oracle.com>
	<1397011424-10970-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbaDIDlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 23:41:06 -0400
In-Reply-To: <1397011424-10970-2-git-send-email-martin.petersen@oracle.com>
	(Martin K. Petersen's message of "Tue, 8 Apr 2014 22:43:44 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> Commit bf36f9cfa6d3d caused a regression by effectively
Martin> reverting Nic's fix from 5837c80e870b that ensures we traverse
Martin> the full bio_vec list upon completion.

Btw. I have a much better fix for this in the next data integrity update
but that's a bit too late for 3.15. This is just a bug fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
