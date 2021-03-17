Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D6CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67CFB64F10
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhCQRzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhCQRzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 13:55:38 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3864C06174A;
        Wed, 17 Mar 2021 10:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Ypyz0j2PEw9gdVaX4v7qk0sBF+uiHCxzyBA37J2T/TI=; b=nIhYv0xmoq9cVrT9MAFkrRcLNm
        HgCxgvRSlG9n79iDIeboxo0ib06fkhlfn3XF3CTyaplKSwajDFRreE7I5d8SQC+98zl7Et24q1lWq
        uRDIYBrXLLPC5hi5Dl//k5tdr1A8yF093CzbMB9ey+534uLsN26+9GUiA6hxU2Ayv1KrXqPMrm4K4
        1rT9FiVqyUPhILGpTjuKvL81r0+ir0VAAV2q2Srupvxm7wieVBixMB7Fk7rUh5Z+RUlowWYpFm8Js
        Q+7gySCF4Kh3OaF7jiXepeIs4hMwCW5GHvdbsvv31p9PCtDhusHs/iY/EZVPpu64AemceGWpsfISU
        9b+ra0AA==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMaOM-001ffw-Av; Wed, 17 Mar 2021 17:55:34 +0000
Subject: Re: [PATCH] scsi: fnic: Rudimentary spelling fixes throughout the
 file fnic_trace.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210317092240.927822-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <22e3b136-60a9-6678-411a-c4e9d16bf8e9@infradead.org>
Date:   Wed, 17 Mar 2021 10:55:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317092240.927822-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 2:22 AM, Bhaskar Chowdhury wrote:
> 
> Rudimentary typo fixes throughout the file.
> 

wow!

> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  drivers/scsi/fnic/fnic_trace.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
> index 9d52d83161ed..4a7536bb0ab3 100644
> --- a/drivers/scsi/fnic/fnic_trace.c
> +++ b/drivers/scsi/fnic/fnic_trace.c
> @@ -153,7 +153,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
>  			if (rd_idx > (fnic_max_trace_entries-1))
>  				rd_idx = 0;
>  			/*
> -			 * Continure dumpping trace buffer entries into
> +			 * Continue dumping trace buffer entries into
>  			 * memory file till rd_idx reaches write index
>  			 */
>  			if (rd_idx == wr_idx)
> @@ -189,7 +189,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
>  				  tbp->data[3], tbp->data[4]);
>  			rd_idx++;
>  			/*
> -			 * Continue dumpping trace buffer entries into
> +			 * Continue dumping trace buffer entries into
>  			 * memory file till rd_idx reaches write index
>  			 */
>  			if (rd_idx == wr_idx)
> @@ -632,7 +632,7 @@ void fnic_fc_trace_free(void)
>   * fnic_fc_ctlr_set_trace_data:
>   *       Maintain rd & wr idx accordingly and set data
>   * Passed parameters:
> - *       host_no: host number accociated with fnic
> + *       host_no: host number associated with fnic
>   *       frame_type: send_frame, rece_frame or link event
>   *       fc_frame: pointer to fc_frame
>   *       frame_len: Length of the fc_frame
> @@ -715,13 +715,13 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
>   * fnic_fc_ctlr_get_trace_data: Copy trace buffer to a memory file
>   * Passed parameter:
>   *       @fnic_dbgfs_t: pointer to debugfs trace buffer
> - *       rdata_flag: 1 => Unformated file
> - *                   0 => formated file
> + *       rdata_flag: 1 => Unformatted file
> + *                   0 => formatted file
>   * Description:
>   *       This routine will copy the trace data to memory file with
>   *       proper formatting and also copy to another memory
> - *       file without formatting for further procesing.
> - * Retrun Value:
> + *       file without formatting for further processing.
> + * Return Value:
>   *       Number of bytes that were dumped into fnic_dbgfs_t
>   */
> 
> @@ -785,10 +785,10 @@ int fnic_fc_trace_get_data(fnic_dbgfs_t *fnic_dbgfs_prt, u8 rdata_flag)
>   *      @fc_trace_hdr_t: pointer to trace data
>   *      @fnic_dbgfs_t: pointer to debugfs trace buffer
>   *      @orig_len: pointer to len
> - *      rdata_flag: 0 => Formated file, 1 => Unformated file
> + *      rdata_flag: 0 => Formatted file, 1 => Unformatted file
>   * Description:
>   *      This routine will format and copy the passed trace data
> - *      for formated file or unformated file accordingly.
> + *      for formatted file or unformatted file accordingly.
>   */
> 
>  void copy_and_format_trace_data(struct fc_trace_hdr *tdata,
> --


-- 
~Randy

