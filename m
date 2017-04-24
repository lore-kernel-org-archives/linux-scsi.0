From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/mac_esp: Replace bogus memory barrier with spinlock
Date: Mon, 24 Apr 2017 18:29:50 -0400
Message-ID: <yq1lgqph21t.fsf@oracle.com>
References: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19173 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978864AbdDXWaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:30:08 -0400
In-Reply-To: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
        (Finn Thain's message of "Sun, 02 Apr 2017 17:08:05 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Finn,

> Commit da244654c66e ("[SCSI] mac_esp: fix for quadras with two esp chips")
> added mac_scsi_esp_intr() to handle the IRQ lines from a pair of on-board
> ESP chips (a normal shared IRQ did not work).
>
> Proper mutual exclusion was missing from that patch. This patch fixes
> race conditions between comparison and assignment of esp_chips[]
> pointers.

Ondrej/Michael: Mind reviewing this change?

-- 
Martin K. Petersen	Oracle Linux Engineering
