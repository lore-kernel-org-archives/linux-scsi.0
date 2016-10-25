From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/7] megaraid_sas: Updates for scsi-next
Date: Mon, 24 Oct 2016 22:01:16 -0400
Message-ID: <yq1k2cx9ogj.fsf@sermon.lab.mkp.net>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23477 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932860AbcJYCB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 22:01:26 -0400
In-Reply-To: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
        (Kashyap Desai's message of "Fri, 21 Oct 2016 06:33:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap,

Kashyap> Changes in v3
Kashyap>  two logical patches created for "Send SYNCHRONIZE_CACHE
Kashyap>  command to firmware"
Kashyap> 	- Send SYNCHRONIZE_CACHE for JBOD to firmware
Kashyap> 	- Send SYNCHRONIZE_CACHE for VD to firmware

I applied patch 4 to 4.9/scsi-fixes and 1-3 to 4.10/scsi-queue.

Once Linus merges patch 4 I'll rebase the 4.10 tree and queue 5-8.

-- 
Martin K. Petersen	Oracle Linux Engineering
