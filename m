From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH] scsi/mac_esp: Replace bogus memory barrier with spinlock
Date: Tue, 25 Apr 2017 11:25:56 +1200
Message-ID: <a3f6ae90-7115-c34c-3a7f-98084e0f7087@gmail.com>
References: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
 <yq1lgqph21t.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:36814 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758648AbdDXX0D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 19:26:03 -0400
Received: by mail-pg0-f54.google.com with SMTP id g2so19421212pge.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2017 16:26:03 -0700 (PDT)
In-Reply-To: <yq1lgqph21t.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Finn Thain <fthain@telegraphics.com.au>, Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Hi Martin,

I must have missed that one - where was it posted to?

Cheers,

	Michael


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
