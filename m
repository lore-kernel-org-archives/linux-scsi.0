Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CCDC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 19:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDDB61992
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 19:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhCVTBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 15:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhCVTA5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 15:00:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60193C061574;
        Mon, 22 Mar 2021 12:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=WlGfP90SG+At/EYwvnkh1kLwSYnuMw8vIcAjx/UJLvE=; b=Fi5Jmr68c/KCwtzaSpEPkfyq0g
        yUsSUDntgZj7aaedol9kR62itDFxkApuYJRbxvbpAM9yCj7SVA3WnpsauJqVxKJs9U2fiVJoFamc1
        UM54HOUDsv6xZLrs9XCi2fetixHmPyG+r2NDEdl2UEifveJdq9Ff4Ha5v/QRBEZIbadE5GBww5pTa
        X4Fj/ehrS6uzloYNTCnCOsO+qO4JrodKKeYLkrqBEaaULMvX+fXuU7yXE7wS8QStPwSTD/PKnWaIb
        4YaLiTa2aoGoqCY3nvyZWdEYQ5QnjqFS27jgji9ENDLutbNHxATh8sM4r+1AsKeKMGs+tyFebyeud
        JYwu0Mvg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOPlw-008wko-Hd; Mon, 22 Mar 2021 19:00:08 +0000
Subject: Re: [PATCH] scsi: lpfc: Fix some typo error
To:     samirweng1979 <samirweng1979@163.com>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210322075645.25636-1-samirweng1979@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a05dc916-a594-0342-6be3-08701473950c@infradead.org>
Date:   Mon, 22 Mar 2021 11:59:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322075645.25636-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 12:56 AM, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> change 'lenth' to 'length'.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 8c23806..658a962 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -5154,7 +5154,7 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
>   * This routine is to get the available extent information.
>   *
>   * Returns:
> - * overall lenth of the data read into the internal buffer.
> + * overall length of the data read into the internal buffer.
>   **/
>  static int
>  lpfc_idiag_extacc_avail_get(struct lpfc_hba *phba, char *pbuffer, int len)
> @@ -5205,7 +5205,7 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
>   * This routine is to get the allocated extent information.
>   *
>   * Returns:
> - * overall lenth of the data read into the internal buffer.
> + * overall length of the data read into the internal buffer.
>   **/
>  static int
>  lpfc_idiag_extacc_alloc_get(struct lpfc_hba *phba, char *pbuffer, int len)
> @@ -5277,7 +5277,7 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
>   * This routine is to get the driver extent information.
>   *
>   * Returns:
> - * overall lenth of the data read into the internal buffer.
> + * overall length of the data read into the internal buffer.
>   **/
>  static int
>  lpfc_idiag_extacc_drivr_get(struct lpfc_hba *phba, char *pbuffer, int len)
> 


-- 
~Randy

