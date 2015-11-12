From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] mptfusion: don't allow negative bytes in kbuf_alloc_2_sgl()
Date: Wed, 11 Nov 2015 20:59:08 -0500
Message-ID: <yq1io58t1ub.fsf@sermon.lab.mkp.net>
References: <20151110221524.GB30281@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45745 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbKLB7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 20:59:20 -0500
In-Reply-To: <20151110221524.GB30281@mwanda> (Dan Carpenter's message of "Wed,
	11 Nov 2015 01:15:24 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> There is a static checker warning here because "bytes" is
Dan> controlled by the user and we cap the upper bound with min() but
Dan> allow negatives.  Negative bytes will result in some nasty warning
Dan> messages but are not super harmful.  Anyway, no one needs negative
Dan> bytes so let's just check for it and return NULL.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
