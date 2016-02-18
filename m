From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD are disabled
Date: Wed, 17 Feb 2016 19:22:11 -0500
Message-ID: <yq1k2m2sw98.fsf@sermon.lab.mkp.net>
References: <20160204042528.GA15599@redhat.com>
	<1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
	<56B316EA.9090803@huawei.com> <yq14mdnhmry.fsf@sermon.lab.mkp.net>
	<56C31295.2020309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48357 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161199AbcBRAWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 19:22:30 -0500
In-Reply-To: <56C31295.2020309@huawei.com> (jiangyiwen@huawei.com's message of
	"Tue, 16 Feb 2016 20:14:13 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiangyiwen <jiangyiwen@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, snitzer@redhat.com, James Bottomley <james.bottomley@hansenpartnership.com>

>>>>> "Yiwen" == jiangyiwen  <jiangyiwen@huawei.com> writes:

Yiwen,

Yiwen> When called scsi_prep_fn return BLKPREP_INVALID, we should use
Yiwen> the same code with BLKPREP_KILL in scsi_prep_return.

You are right!

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
