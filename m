From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/3] Fix panic when a SES device is attached to a hpsa logical volume.
Date: Thu, 18 Aug 2016 22:24:11 -0400
Message-ID: <yq17fbdijhw.fsf@sermon.lab.mkp.net>
References: <cover.1471426748.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37704 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbcHSCYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 22:24:22 -0400
In-Reply-To: <cover.1471426748.git.jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 17 Aug 2016 11:46:15 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> The first patch provides stub implementations for
Johannes> scsi_is_sas_phy() and sas_get_address() for the case that
Johannes> CONFIG_SCSI_SAS_ATTRS is not defined.

Johannes> The second patch implements the actual fix in ses.c by
Johannes> changing the is_sas_attached() call to scsi_is_sas_rphy().

Johannes> The third and last patch removes is_sas_attached() as it
Johannes> doesn't have any more consumers left.

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
