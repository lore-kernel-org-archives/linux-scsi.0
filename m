From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] osd_uld: Check scsi_device_get() return value
Date: Thu, 06 Apr 2017 12:44:39 -0400
Message-ID: <yq1lgrdqydk.fsf@oracle.com>
References: <1D08B61A9CF0974AA09887BE32D889DA12E934@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38616 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934395AbdDFQot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 12:44:49 -0400
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA12E934@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
        (Bart Van Assche's message of "Thu, 30 Mar 2017 17:17:17 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Boaz Harrosh <ooo@electrozaur.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

Bart,

> scsi_device_get() can fail. Hence check its return value.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
