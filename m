From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: enable no vccq quirk for skhynix device
Date: Wed, 28 Sep 2016 01:09:25 -0400
Message-ID: <yq1r384y5iy.fsf@sermon.lab.mkp.net>
References: <1474901905-21551-1-git-send-email-kyuho.choi@sk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17750 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbcI1FJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 01:09:34 -0400
In-Reply-To: <1474901905-21551-1-git-send-email-kyuho.choi@sk.com> (Kyuho
        Choi's message of "Mon, 26 Sep 2016 23:58:25 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyuho Choi <chlrbgh0@gmail.com>
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Kyuho Choi <kyuho.choi@sk.com>

>>>>> "Kyuho" == Kyuho Choi <chlrbgh0@gmail.com> writes:

Kyuho> This patch enable no vccq quirk for SKHynix devices.  SKHynix ufs
Kyuho> device don't need vccq vrail for device operation.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
