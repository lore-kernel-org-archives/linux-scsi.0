From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Fix INTx/MSI-x issue with older controllers
Date: Thu, 09 Feb 2017 18:59:20 -0500
Message-ID: <yq1h942kjaf.fsf@oracle.com>
References: <20170209180447.31404-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36386 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdBIX7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 18:59:31 -0500
In-Reply-To: <20170209180447.31404-1-david.carroll@microsemi.com> (Dave
        Carroll's message of "Thu, 9 Feb 2017 11:04:47 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, stable@vger.kernel.org

>>>>> "Dave" == Dave Carroll <david.carroll@microsemi.com> writes:

Dave> commit 78cbccd3bd683 ("[PATCH] aacraid: Fix for KDUMP driver
Dave> hang") caused a problem on older controllers which do not support
Dave> MSI-x (namely ASR3405,ASR3805). This patch conditionalizes the
Dave> previous patch to controllers which support MSI-x

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
