From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 00/22]  qla2xxx: Bug fixes for 4.15-rc2
Date: Wed, 06 Dec 2017 21:43:55 -0500
Message-ID: <yq1bmjbxno4.fsf@oracle.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
        <yq1k1y16heg.fsf@oracle.com>
        <E2C1FCEE-E4A1-4942-A711-730ABF4E4A4D@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdLGCoE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2017 21:44:04 -0500
In-Reply-To: <E2C1FCEE-E4A1-4942-A711-730ABF4E4A4D@cavium.com> (Himanshu
        Madhani's message of "Tue, 5 Dec 2017 05:28:09 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Himanshu,

>> This looks pretty big for a series of bug fixes. Are all these
>> patches really candidates for 4.15 and stable backports all the way
>> back to 4.10?

> Yes Please. I would want them back ported to 4.10 since these issues
> were discovered in combination of 4.10/4.11 kernel.

James already sent Linus a pull request for this week. So that would put
your series out another week. 22 patches and 400+ insertions. That's a
lot of churn for rc4, and while the changes are indeed fixes and not new
features, the whole thing still looks like a regular merge window driver
update to me.

This series really should have been posted before the 4.15 merge window
opened. However, the first iteration of this series was posted after rc1
was out. I'm terribly sorry, but that's just too late for something this
size.

I queued everything up for 4.16.

-- 
Martin K. Petersen	Oracle Linux Engineering
