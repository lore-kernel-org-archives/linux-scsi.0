From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V6 1/4] [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
Date: Sun, 24 Feb 2013 17:55:39 +0530
Message-ID: <CAKVbJB-Xaq-ORfD6+bzprvGefnZtM2UjLMUW=qg7Nwnw3QwVBw@mail.gmail.com>
References: <511137d6.0657420a.5b57.ffffa7eb@mx.google.com>
	<1361697785.16652.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50306 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab3BXMZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2013 07:25:40 -0500
In-Reply-To: <1361697785.16652.1.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, saugata.das@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org

On Sun, Feb 24, 2013 at 2:53 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2013-02-05 at 22:17 +0530, vinholikatti@gmail.com wrote:
>> From: Vinayak Holikatti <vinholikatti@gmail.com>
>>
>> This patch seggregates the PCI specific code in ufshcd.c to make it
>> ready for splitting into core ufs driver and PCI glue driver. Also
>> copyright header modification to remove extra warranty disclaim.
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
>> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
>> ---
>>  drivers/scsi/ufs/Kconfig  |   50 +++----
>>  drivers/scsi/ufs/ufs.h    |   44 +++----
>>  drivers/scsi/ufs/ufshcd.c |  350 +++++++++++++++++++++++++++------------------
>>  drivers/scsi/ufs/ufshci.h |   44 +++----
>>  4 files changed, 268 insertions(+), 220 deletions(-)
>
> This patch doesn't apply:
>
> jejb@dabdike> patch -p1 < .git/rebase-apply/patch
> patching file drivers/scsi/ufs/Kconfig
> patching file drivers/scsi/ufs/ufs.h
> patching file drivers/scsi/ufs/ufshcd.c
> Hunk #26 FAILED at 1823.
> Hunk #27 succeeded at 1898 (offset -1 lines).
> Hunk #28 succeeded at 1924 (offset -1 lines).
> Hunk #29 FAILED at 2039.
> 2 out of 29 hunks FAILED -- saving rejects to file
> drivers/scsi/ufs/ufshcd.c.rej
> patching file drivers/scsi/ufs/ufshci.h
>
> The rejects are pretty complex hunks; could you please rebase to the top
> of the scsi-misc tree?  Thanks,

Ok, I will do it.

>
> James
>
>
