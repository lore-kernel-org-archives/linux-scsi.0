From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: add missing KERN_CONT for disk spin-up
Date: Mon, 04 Dec 2017 22:28:16 -0500
Message-ID: <yq1lgih4zvz.fsf@oracle.com>
References: <2a37c111d0ffed64653921fc405c7a17be64a41a.1511542918.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:24842 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbdLED3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 22:29:36 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vB53SumV025533
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 5 Dec 2017 03:29:26 GMT
In-Reply-To: <2a37c111d0ffed64653921fc405c7a17be64a41a.1511542918.git.mirq-linux@rere.qmqm.pl>
        (=?utf-8?Q?=22Micha=C5=82_Miros=C5=82aw=22's?= message of "Fri, 24 Nov 2017
 18:02:35 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>


Michał,

> KERN_CONT is now required for continued printks(). Add it.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
