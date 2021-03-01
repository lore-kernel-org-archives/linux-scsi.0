Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5B1C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EA1650F0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhCAQ7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 11:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhCAQ4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 11:56:54 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2849CC06178A;
        Mon,  1 Mar 2021 08:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=0ZkLluOrTrBUf/RMiNaSJ0dAQzd0kY6PSCyH9eHVbi4=; b=XW1AovFNhTutWc2Rh7syqWIOHv
        TFgukI3gFpCXM3Xe8jP0V26E69/AeNPDzc6ZFZcr+vSs1fp3y9C9eLCy77srQA7F7AF80T2qBddJE
        3iGrZFciUfEE1Z1M9bP+76IAqm4y88SoD5k1PjR43xylCW9VkS+OchDRss1e1xUGPved0dswpG4d3
        3X2XXOiptEylrHNTkZxWyWVCboEu0uPX3nowzT7La+6bT7Hrw3WHsF7wq5cmYX9+8fTg0MY04aEX0
        CkRC7y/xJIAHWj15hmCVstTTc47G2h/+zklhDiaYGFYgpvtw+ge4EXeMuL+PIwrstUBObHlz2R9zm
        OQM5ZsqQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lGlq2-0004e0-8u; Mon, 01 Mar 2021 16:56:06 +0000
Subject: Re: [PATCH] drivers: scsi: qla4xxx: Fix a spello in the file
 qla4xxx/ql4_os.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210301131736.14236-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e45931a9-b90e-8894-7081-61298c76abac@infradead.org>
Date:   Mon, 1 Mar 2021 08:56:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210301131736.14236-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/21 5:17 AM, Bhaskar Chowdhury wrote:
> 
> s/circuting/circuiting/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

However:
In lots of your patches, the subject begins with drivers:
and we don't need that.  See the SCSI qla4xxx driver patches, e.g.:

$ git log --oneline drivers/scsi/qla4xxx/
5b0ec4cf0494 scsi: qla4xxx: Use iscsi_is_session_online()
35f1cad1f928 scsi: qla4xxx: Use standard SAM status definitions
3a5b9fa2cc5f scsi: qla4xxx: Remove redundant assignment to variable rval
014aced18aff scsi: qla4xxx: Remove in_interrupt() from qla4_82xx_rom_lock()
3627668c2e2c scsi: qla4xxx: Remove in_interrupt() from qla4_82xx_idc_lock()
a93c38353198 scsi: qla4xxx: Remove in_interrupt()
cf4d4d8ebdb8 scsi: qla4xxx: Remove redundant assignment to variable rval
5ccdd101351d scsi: qla4xxx: Fix inconsistent format argument type
121432e87093 scsi: qla4xxx: Delete unneeded variable 'status' in qla4xxx_process_ddb_changed
e3976af5a475 scsi/qla4xxx: Convert to SPDX license identifiers
574918e69720 scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'
d10d1df6301d scsi: qla4xxx: Rename function parameter descriptions
6e3f4f68821b scsi: qla4xxx: Remove set but unused variable 'status'
653557df36e0 scsi: qla4xxx: Supply description for 'code'
f67e81641db7 scsi: qla4xxx: Remove three set but unused variables
c0ad04b4b6d7 scsi: qla4xxx: Document qla4xxx_process_ddb()'s 'conn_err'
fc5fba6e2ae2 scsi: qla4xxx: Repair function documentation headers
cdeeb36d8f24 scsi: qla4xxx: Fix some kerneldoc parameter documentation issues
67b8b93a559f scsi: qla4xxx: Fix incorrectly named function parameter
0d5fea42989e scsi: qla4xxx: Fix-up incorrectly documented parameter

> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index a4b014e1cd8c..716a5827588c 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -6961,7 +6961,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
>  	if (is_reset == RESET_ADAPTER) {
>  		iscsi_block_session(cls_sess);
>  		/* Use the relogin path to discover new devices
> -		 *  by short-circuting the logic of setting
> +		 *  by short-circuiting the logic of setting
>  		 *  timer to relogin - instead set the flags
>  		 *  to initiate login right away.
>  		 */
> --


-- 
~Randy

