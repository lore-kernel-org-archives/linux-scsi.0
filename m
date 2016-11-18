From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] libfc: fix seconds_since_last_reset miscalculation
Date: Thu, 17 Nov 2016 20:21:52 -0500
Message-ID: <yq17f818tvz.fsf@sermon.lab.mkp.net>
References: <1479386367-63443-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24523 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbcKRBWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 20:22:09 -0500
In-Reply-To: <1479386367-63443-1-git-send-email-jthumshirn@suse.de> (Johannes
        Thumshirn's message of "Thu, 17 Nov 2016 13:39:27 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Commit 540eb1eef 'scsi: libfc: fix seconds_since_last_reset
Johannes> calculation' removed the use of 'struct timespec' from
Johannes> fc_get_host_stats(). This broke the output of 'fcoeadm -s'
Johannes> after kernel 4.8-rc1.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
