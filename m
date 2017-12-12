From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 18/45] drivers: scsi: qla2xxx: remove duplicate includes
Date: Mon, 11 Dec 2017 21:53:04 -0500
Message-ID: <yq14lowr71r.fsf@oracle.com>
References: <1512580083-5750-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdLLCxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 21:53:15 -0500
In-Reply-To: <1512580083-5750-1-git-send-email-pravin.shedge4linux@gmail.com>
        (Pravin Shedge's message of "Wed, 6 Dec 2017 22:38:03 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org


Pravin,

> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
