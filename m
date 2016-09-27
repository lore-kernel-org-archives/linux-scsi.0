From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH next] scsi: fcoe: fix off by one in eth2fc_speed()
Date: Mon, 26 Sep 2016 20:55:31 -0400
Message-ID: <yq1vaxi2mbg.fsf@sermon.lab.mkp.net>
References: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
        <20160921205407.6304-1-vincent.stehle@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22434 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754852AbcI0A4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 20:56:11 -0400
In-Reply-To: <20160921205407.6304-1-vincent.stehle@laposte.net> ("Vincent
        =?utf-8?Q?Stehl=C3=A9=22's?= message of "Wed, 21 Sep 2016 22:54:07 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vincent =?utf-8?Q?Stehl=C3=A9?= <vincent.stehle@laposte.net>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Vincent" == Vincent Stehlé <vincent.stehle@laposte.net> writes:

Vincent> This should be "< ARRAY_SIZE()" instead of "<= ARRAY_SIZE()".

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
