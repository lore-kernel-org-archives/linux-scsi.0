From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] dpt_i2o: Add a missing call to kfree
Date: Tue, 29 Nov 2016 11:55:02 -0500
Message-ID: <yq1a8cins49.fsf@sermon.lab.mkp.net>
References: <20161119174234.20292-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27091 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbcK2Qzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:55:40 -0500
In-Reply-To: <20161119174234.20292-1-lambert.quentin@gmail.com> (Quentin
        Lambert's message of "Sat, 19 Nov 2016 18:42:34 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Quentin" == Quentin Lambert <lambert.quentin@gmail.com> writes:

Quentin> Most error branches following the call to kzalloc contain a
Quentin> call to kfree. This patch add these calls where they are
Quentin> missing.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
