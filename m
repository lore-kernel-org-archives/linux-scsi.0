From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch v2] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Thu, 15 Sep 2016 09:59:01 -0400
Message-ID: <yq17fadz2l6.fsf@sermon.lab.mkp.net>
References: <20160915134456.GA30277@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25987 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757748AbcION7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 09:59:18 -0400
In-Reply-To: <20160915134456.GA30277@mwanda> (Dan Carpenter's message of "Thu,
        15 Sep 2016 16:44:56 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, Hannes Reinicke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, security@kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> We need to put an upper bound on "user_len" so the memcpy() doesn't
Dan> overflow.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
