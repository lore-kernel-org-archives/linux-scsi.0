From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: remove unnecessary goto label
Date: Fri, 15 Jul 2016 15:45:10 -0400
Message-ID: <yq1vb06heih.fsf@sermon.lab.mkp.net>
References: <73f0ab56.2322.15585d73a9e.Coremail.kernelpatch@126.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20023 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbcGOTpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:45:30 -0400
In-Reply-To: <73f0ab56.2322.15585d73a9e.Coremail.kernelpatch@126.com> (Tiezhu
	Yang's message of "Sat, 25 Jun 2016 12:35:22 +0800 (CST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tiezhu Yang <kernelpatch@126.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Tiezhu" == Tiezhu Yang <kernelpatch@126.com> writes:

Tiezhu> When buff_ascii kmalloc failed, there is no need to call kfree,
Tiezhu> it should return -ENOMEM directly, this patch fixes it.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
