From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: Fix memory leak in beiscsi_alloc_mem()
Date: Thu, 11 Feb 2016 09:34:29 -0500
Message-ID: <yq1vb5v5n9m.fsf@sermon.lab.mkp.net>
References: <1443689785-13712-1-git-send-email-mlombard@redhat.com>
	<CAJRCtXfbT9OrVVDrnC=1V1B4iFUm+FHN4fxQV1CUCY3pXRHq2Q@mail.gmail.com>
	<026a01d164cc$0eed1720$2cc74560$@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20454 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbcBKOen (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 09:34:43 -0500
In-Reply-To: <026a01d164cc$0eed1720$2cc74560$@broadcom.com> (Jitendra
	Bhivare's message of "Thu, 11 Feb 2016 04:59:31 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: linux-scsi@vger.kernel.org, mlombard@redhat.com, jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, James.Bottomley@hansenpartnership.com

>>>>> "Jitendra" == Jitendra Bhivare <jitendra.bhivare@broadcom.com> writes:

Jitendra> In case of error, the memory allocated for phwi_ctrlr was not
Jitendra> freed.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
