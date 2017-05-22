From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: smartpqi: mark PM functions as __maybe_unused
Date: Mon, 22 May 2017 14:49:02 +0200
Message-ID: <CAK8P3a3-_WZb6ua+gE4+p-5f8311dR3rMt+se-YZe1m3VXw+dA@mail.gmail.com>
References: <20170518083243.2927102-1-arnd@arndb.de> <CAK8P3a2KD5aJanDcaRUHi2GeotJ_pfC_UY+KrWdYua1_k3GYow@mail.gmail.com>
 <yq14lwh4noe.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35161 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757963AbdEVMtR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 08:49:17 -0400
In-Reply-To: <yq14lwh4noe.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kevin Barnett <kevin.barnett@microsemi.com>

On Fri, May 19, 2017 at 3:53 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Arnd,
>
>> I notice that today's linux-next no longer contains the patch that
>> introduced the warning.
>
> I had tagged my 4.12 fixes branch with for-next. It should be back to
> 4.13 material shortly.

Ok, the patch is back now, so my fix is needed again. Let me know
in case you want me to resend.

        Arnd
