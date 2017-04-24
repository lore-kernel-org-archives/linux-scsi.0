From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/mac_esp: Replace bogus memory barrier with spinlock
Date: Mon, 24 Apr 2017 19:29:41 -0400
Message-ID: <yq1vaptfkpm.fsf@oracle.com>
References: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
        <yq1lgqph21t.fsf@oracle.com>
        <a3f6ae90-7115-c34c-3a7f-98084e0f7087@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38621 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1174691AbdDXXaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 19:30:00 -0400
In-Reply-To: <a3f6ae90-7115-c34c-3a7f-98084e0f7087@gmail.com> (Michael
        Schmitz's message of "Tue, 25 Apr 2017 11:25:56 +1200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Finn Thain <fthain@telegraphics.com.au>, Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Michael,

> I must have missed that one - where was it posted to?

Usual bat channel:

https://patchwork.kernel.org/patch/9658369/

-- 
Martin K. Petersen	Oracle Linux Engineering
