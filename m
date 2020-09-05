Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D05C43461
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 21:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD8E20760
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 21:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sf1RTTj+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgIEVRG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 17:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgIEVRE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 17:17:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5DDC061244;
        Sat,  5 Sep 2020 14:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=9HVhvVwQsPl2s5OBkHl5FVvyzy/fk4PJlFsUEzCu4Fw=; b=Sf1RTTj+yITwRXpvzoMqMM7pGD
        8EuJG+UMj4Ayd9jviLU0cQZ3duxk0YAWOjrTyjOygQXBVxEHeGt+mE0lVj5q1LhgXI/KcQPX3PT8I
        rrgwZHed+EGRhYW5zkKaZNqzoMGo/qLx+8xupROYuv3lq6eCYJXYB9vTBQykLU9pBt5aEqcldtvUc
        vMy5uXj9fW6AHOI+xsw4D6X+VVO7bRKEp11qoPv5148AuTTKvKELBEEmCtPO4NGb0QNPQU7uY+/vi
        CwUuQt1WywMmfhFAP79dd0mUe3ZTQw8GrFN6uHJ7v4hJ33NBz/ErhVa8/1k9vbeGdZc57v3QXURJw
        irU8TLlw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kEfYK-00057z-9H; Sat, 05 Sep 2020 21:16:52 +0000
Subject: Re: [PATCH] scsi: docs: Remove obsolete scsi typedef text from
 scsi_mid_low_api
To:     =?UTF-8?B?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= 
        <nfraprado@protonmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org,
        andrealmeid@collabora.com
References: <20200905210211.2286172-1-nfraprado@protonmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e7f2c4f2-0d61-3734-2898-024592886e60@infradead.org>
Date:   Sat, 5 Sep 2020 14:16:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200905210211.2286172-1-nfraprado@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/5/20 2:03 PM, Nícolas F. R. A. Prado wrote:
> Commit 91ebc1facd77 ("scsi: core: remove Scsi_Cmnd typedef") removed
> the Scsi_cmnd typedef but it was still mentioned in a paragraph in the
> "SCSI mid_level - lower_level driver interface" documentation page.
> Remove this obsolete paragraph.
> 
> Suggested-by: Randy Dunlap <rdunlap@infradead.org>
> Suggested-by: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: Nícolas F. R. A. Prado <nfraprado@protonmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> 
> Hi,
> 
> Is this documentation page still relevant or should it be removed? I'm asking
> since it hasn't been updated in a while and there's mention of 2.6 kernel.
> 
> In case it is still relevant, would patches changing the embedded kernel-docs
> for references to the kernel-docs in the source files be welcome?
> Also, I see that for example, scsi_add_device, has a kernel-doc in this page,
> even though there isn't any in the source code. Would a patch moving this
> function description to the source code be welcome?
> 
> Thanks,
> Nícolas
> 
>  Documentation/scsi/scsi_mid_low_api.rst | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 5358bc10689e..5bc17d012b25 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -271,12 +271,6 @@ Conventions
>  First, Linus Torvalds's thoughts on C coding style can be found in the
>  Documentation/process/coding-style.rst file.
>  
> -Next, there is a movement to "outlaw" typedefs introducing synonyms for
> -struct tags. Both can be still found in the SCSI subsystem, but
> -the typedefs have been moved to a single file, scsi_typedefs.h to
> -make their future removal easier, for example:
> -"typedef struct scsi_cmnd Scsi_Cmnd;"
> -
>  Also, most C99 enhancements are encouraged to the extent they are supported
>  by the relevant gcc compilers. So C99 style structure and array
>  initializers are encouraged where appropriate. Don't go too far,
> 


-- 
~Randy
