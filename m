Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351ACC6377C
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC19461264
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbhGUKFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239057AbhGUKCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jul 2021 06:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D15C061009;
        Wed, 21 Jul 2021 10:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626864171;
        bh=8fb/gi2w4q3KB14K+Qv3nuZ/0WYWYFXybte7Wm4zgs8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3y9YcOTEu6N20eoZWnKCvomtRdf7DJhhnihpVaHAoDg6rS4fzgDdd/YryZcaK77R
         ivI+ySpmDscBpu6uUVu7s/jcSJ7f0n5o4oWT6g+72AYvJHWFfLf4yUCcbKR/OYSf9d
         P1O4vAmyJg5JZXuRc2+I+4qqU/D+M/HNoB5w/rhtip18lMwl3vffmMQpChICXKwrAC
         9MykELJZLV/jIC/oYiwX3hp3oDqDIiKFA1ELit29I6HyovJjiADtQc1aLyocrFioIf
         v5nSQ0I7z699irk6XA5/ima6vY37Imirnewexg1z3N6bOTP1pIsoC8BM1fMcFN4hCP
         4rpZZDjW6Kutg==
Date:   Wed, 21 Jul 2021 06:42:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 17/18] scsi: be2iscsi: Fix some missing space
 in some messages
Message-ID: <YPf6KXaz+LLnC0vi@sashalap>
References: <20210714194806.55962-1-sashal@kernel.org>
 <20210714194806.55962-17-sashal@kernel.org>
 <615a1135-bbb0-0384-8499-716f26fba08a@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <615a1135-bbb0-0384-8499-716f26fba08a@wanadoo.fr>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 16, 2021 at 09:22:43PM +0200, Marion & Christophe JAILLET wrote:
>
>Le 14/07/2021 à 21:48, Sasha Levin a écrit :
>>From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>
>>[ Upstream commit c7fa2c855e892721bafafdf6393342c000e0ef77 ]
>>
>>Fix a few style issues reported by checkpatch.pl:
>>
>>  - Avoid duplicated word in comment.
>>
>>  - Add missing space in messages.
>>
>>  - Unneeded continuation line character.
>>
>>  - Unneeded extra spaces.
>>
>>  - Unneeded log message after memory allocation failure.
>>
>>Link: https://lore.kernel.org/r/8cb62f0eb96ec7ce7a73fe97cb4490dd5121ecff.1623482155.git.christophe.jaillet@wanadoo.fr
>>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi,
>
>I always appreciate to have some patches backported, but in this 
>particular case, I wonder what is the rational to backport up to 4.9 
>some checkpatch warning about log message?
>
>Keeping code aligned to ease other future backport?
>
>I thought that the rule for backport was that it needed to fix a real 
>issue (and sometimes a real 'potential' issue)

I think that I brought it in as a dependency for something else, but I
don't see what it was. I'll drop it then, thanks!

-- 
Thanks,
Sasha
