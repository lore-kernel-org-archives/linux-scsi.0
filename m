From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Thu, 18 Aug 2016 22:19:02 -0400
Message-ID: <yq1bn0pijqh.fsf@sermon.lab.mkp.net>
References: <1471349112-13876-1-git-send-email-oneukum@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36660 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753820AbcHSCTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 22:19:24 -0400
In-Reply-To: <1471349112-13876-1-git-send-email-oneukum@suse.com> (Oliver
        Neukum's message of "Tue, 16 Aug 2016 14:05:12 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, jthumshirn@suse.com, mdharm-usb@one-eyed-alien.net, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com

>>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:

Oliver> Some SATA to USB bridges fail to cooperate with some drives
Oliver> resulting in no cache being present being reported to the
Oliver> host. That causes the host to skip sending a command to
Oliver> synchronize caches. That causes data loss when the drive is
Oliver> powered down.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
