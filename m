Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3FCC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 17:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351904AbiCUR7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 13:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbiCUR7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 13:59:12 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A21160164
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 10:57:45 -0700 (PDT)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id WMHlnEz17SDrIWMHlnJ4cZ; Mon, 21 Mar 2022 18:57:43 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 21 Mar 2022 18:57:43 +0100
X-ME-IP: 90.126.236.122
Message-ID: <7ef297b7-0de4-2ee2-aa3d-c70fa1ad7a3a@wanadoo.fr>
Date:   Mon, 21 Mar 2022 18:57:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] zorro: Fix a resource leak in zorro7xx_remove_one()
Content-Language: fr
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>
References: <247066a3104d25f9a05de8b3270fc3c848763bcc.1647673264.git.christophe.jaillet@wanadoo.fr>
 <CAMuHMdUgXek+BDT4vJQfFcwDgQfyDAB=wXfdC0poynzH26=okw@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <CAMuHMdUgXek+BDT4vJQfFcwDgQfyDAB=wXfdC0poynzH26=okw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 21/03/2022 à 10:00, Geert Uytterhoeven a écrit :
> Hi Christophe,
> 
> On Sat, Mar 19, 2022 at 8:01 AM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>> The error handling path of the probe releases a resource that is not freed
>> in the remove function.
>>
>> In some cases, a ioremap() must be undone.
>>
>> Add the missing iounmap() call in the remove function.
>>
>> Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Thanks for your patch!
> 
> The online-summary should be
> "scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()".

Hi,
should I send a V2 or can this be fixed when/if applied?

CJ

> 
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
> 

