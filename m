From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: avoid double free of resource identifiers
Date: Wed, 11 Jan 2017 22:57:39 -0500
Message-ID: <yq1d1ftnd58.fsf@oracle.com>
References: <20170111100642.18573-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50852 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdALD5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 22:57:47 -0500
In-Reply-To: <20170111100642.18573-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 11 Jan 2017 11:06:42 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>, Roberto Sassu <rsassu@suse.de>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Set variables initialized in
Johannes> lpfc_sli4_alloc_resource_identifiers() to NULL if an error
Johannes> occurred. Otherwise, lpfc_sli4_driver_resource_unset()
Johannes> attempts to free the memory again.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
