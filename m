From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: Remove comparison of u16 idx with zero.
Date: Mon, 26 Jun 2017 13:43:57 -0400
Message-ID: <yq1k23y4pb6.fsf@oracle.com>
References: <1498321485-21677-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26663 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdFZRoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:44:06 -0400
In-Reply-To: <1498321485-21677-1-git-send-email-chris.gekas@gmail.com>
        (Christos Gkekas's message of "Sat, 24 Jun 2017 17:24:45 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Christos,

> Variable idx is defined as u16 thus statement (idx < 0) is always
> false and should be removed.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
