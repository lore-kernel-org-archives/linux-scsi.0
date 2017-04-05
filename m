From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sas: remove sas_domain_release_transport
Date: Tue, 04 Apr 2017 20:17:28 -0400
Message-ID: <yq1zifvu2qv.fsf@oracle.com>
References: <20170403143250.14125-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25429 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755084AbdDEARj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 20:17:39 -0400
In-Reply-To: <20170403143250.14125-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Mon, 3 Apr 2017 16:32:50 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes,

> sas_domain_release_transport is unused since at least v3.13, remove
> it.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
