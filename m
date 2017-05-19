From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: mark PM functions as __maybe_unused
Date: Thu, 18 May 2017 21:53:37 -0400
Message-ID: <yq14lwh4noe.fsf@oracle.com>
References: <20170518083243.2927102-1-arnd@arndb.de>
        <CAK8P3a2KD5aJanDcaRUHi2GeotJ_pfC_UY+KrWdYua1_k3GYow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49450 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753200AbdESBxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 21:53:49 -0400
In-Reply-To: <CAK8P3a2KD5aJanDcaRUHi2GeotJ_pfC_UY+KrWdYua1_k3GYow@mail.gmail.com>
        (Arnd Bergmann's message of "Thu, 18 May 2017 11:09:16 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kevin Barnett <kevin.barnett@microsemi.com>


Arnd,

> I notice that today's linux-next no longer contains the patch that
> introduced the warning.

I had tagged my 4.12 fixes branch with for-next. It should be back to
4.13 material shortly.

-- 
Martin K. Petersen	Oracle Linux Engineering
