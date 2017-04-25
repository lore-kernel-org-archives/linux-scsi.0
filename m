From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH] scsi/mac_esp: Replace bogus memory barrier with spinlock
Date: Tue, 25 Apr 2017 14:14:47 +1200
Message-ID: <c4715424-f497-9fe0-a3a4-22efb1076046@gmail.com>
References: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
 <yq1lgqph21t.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36670 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S979949AbdDYCO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 22:14:56 -0400
In-Reply-To: <yq1lgqph21t.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Finn Thain <fthain@telegraphics.com.au>, Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Martin,

looks good to me, so:

Reviewed-By: Michael Schmitz <schmitzmic@gmail.com>


Am 25.04.2017 um 10:29 schrieb Martin K. Petersen:
> 
> Finn,
> 
>> Commit da244654c66e ("[SCSI] mac_esp: fix for quadras with two esp chips")
>> added mac_scsi_esp_intr() to handle the IRQ lines from a pair of on-board
>> ESP chips (a normal shared IRQ did not work).
>>
>> Proper mutual exclusion was missing from that patch. This patch fixes
>> race conditions between comparison and assignment of esp_chips[]
>> pointers.
> 
> Ondrej/Michael: Mind reviewing this change?
> 
