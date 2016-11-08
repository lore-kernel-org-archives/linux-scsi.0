From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
Date: Tue, 08 Nov 2016 18:15:22 -0500
Message-ID: <yq1mvh9r2b9.fsf@sermon.lab.mkp.net>
References: <f0fa381c-e224-b660-27c4-dede4a5b543e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40061 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbcKHXPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 18:15:31 -0500
In-Reply-To: <f0fa381c-e224-b660-27c4-dede4a5b543e@kernel.dk> (Jens Axboe's
        message of "Tue, 8 Nov 2016 10:42:37 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:

Jens> I wasted half a day on this, thinking it was something in my
Jens> 4.10 branches. But it turns out it is not, the regression is in
Jens> mainline.

Kashyap, have you tested the stable fix without the remainder of the
driver update in place?

-- 
Martin K. Petersen	Oracle Linux Engineering
