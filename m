From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: logging: update description of logging_level bits
Date: Wed, 11 Oct 2017 14:22:46 -0400
Message-ID: <yq1inflfssp.fsf@oracle.com>
References: <405824b6-5dd7-dc34-55a9-c11f69e2fabd@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29431 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752254AbdJKSXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 14:23:16 -0400
In-Reply-To: <405824b6-5dd7-dc34-55a9-c11f69e2fabd@infradead.org> (Randy
        Dunlap's message of "Wed, 11 Oct 2017 10:09:23 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Kyle Fortin <kyle.fortin@oracle.com>, Steffen Maier <maier@linux.vnet.ibm.com>


Randy,

> Update the description of 'scsi_logging_level' from 8 4-bit nibbles
> to the (pre-git) reality of 10 3-bit bitfields.

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
