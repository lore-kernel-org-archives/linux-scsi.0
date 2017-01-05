From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs-qcom: Fix module autoload
Date: Thu, 05 Jan 2017 18:21:01 -0500
Message-ID: <yq1r34hjdpe.fsf@oracle.com>
References: <1483365898-30166-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34619 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030936AbdAEXVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 18:21:09 -0500
In-Reply-To: <1483365898-30166-1-git-send-email-javier@osg.samsung.com>
        (Javier Martinez Canillas's message of "Mon, 2 Jan 2017 11:04:58
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

>>>>> "Javier" == Javier Martinez Canillas <javier@osg.samsung.com> writes:

Javier> If the driver is built as a module, autoload won't work because
Javier> the module alias information is not filled. So user-space can't
Javier> match the registered device with the corresponding module.

Javier> Export the module alias information using the
Javier> MODULE_DEVICE_TABLE() macro.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
