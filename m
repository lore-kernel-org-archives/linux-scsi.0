From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: use %phN for short hex dumps
Date: Mon, 05 Dec 2016 17:06:05 -0500
Message-ID: <yq17f7evxo2.fsf@sermon.lab.mkp.net>
References: <1480545348-32669-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20109 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbcLEWGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 17:06:16 -0500
In-Reply-To: <1480545348-32669-1-git-send-email-linux@rasmusvillemoes.dk>
        (Rasmus Villemoes's message of "Wed, 30 Nov 2016 23:35:47 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Rasmus" == Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

Rasmus> Passing one instead of 8 or 16 arguments reduces the size of the
Rasmus> generated code somewhat:

Rasmus> add/remove: 2/3 grow/shrink: 1/4 up/down: 1772/-2137 (-365)

Rasmus> There's one more candidate, unique_id_show, but that uses %02X,
Rasmus> and I'm not sure it would be ok to start using lowercase there,
Rasmus> so I've left it alone for now.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
