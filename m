Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CBFC433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B24223BF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="SN/r1JhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390509AbgJTCSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:18:43 -0400
Received: from z5.mailgun.us ([104.130.96.5]:53762 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730281AbgJTCSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 22:18:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603160322; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lMfm6HKzFMEeywpRhBcHqJN+vD36Sgop5E0kgiio9W4=;
 b=SN/r1JhRaUXxG3Ph5+a4w56Kom6RmWn2OuNBnGb8ZBGfKqOXLXiS5/hrE2nycQ+VzE3QXHsZ
 Xeonj1LMdzioO3dVRfBjF6Og8caIW9r48gqKmLlQOZRTgVVx7Rkizbqayyxin5qxOGRsL8jJ
 luhbU2fxSFQSeYFn1yymHW9ZGt8=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f8e4901ad37af35ecadf959 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 20 Oct 2020 02:18:41
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C31FC43385; Tue, 20 Oct 2020 02:18:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A25F2C433F1;
        Tue, 20 Oct 2020 02:18:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Oct 2020 10:18:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 4/4] scsi: add more contexts in the ufs tracepoints
In-Reply-To: <20201005223635.2922805-4-jaegeuk@kernel.org>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
 <20201005223635.2922805-4-jaegeuk@kernel.org>
Message-ID: <f55c7b379283bfb90e884e9b1bdf170e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-06 06:36, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> This adds user-friendly tracepoints with group id.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c  |  6 ++++--
>  include/trace/events/ufs.h | 21 +++++++++++++++++----
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 76e95963887be..a2db8182663da 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -336,7 +336,7 @@ static void ufshcd_add_command_trace(struct ufs_hba 
> *hba,
>  		unsigned int tag, const char *str)
>  {
>  	sector_t lba = -1;
> -	u8 opcode = 0;
> +	u8 opcode = 0, group_id = 0;
>  	u32 intr, doorbell;
>  	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>  	struct scsi_cmnd *cmd = lrbp->cmd;
> @@ -362,13 +362,15 @@ static void ufshcd_add_command_trace(struct 
> ufs_hba *hba,
>  				lba = cmd->request->bio->bi_iter.bi_sector;
>  			transfer_len = be32_to_cpu(
>  				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
> +			if (opcode == WRITE_10)
> +				group_id = lrbp->cmd->cmnd[6];
>  		}
>  	}
> 
>  	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>  	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  	trace_ufshcd_command(dev_name(hba->dev), str, tag,
> -				doorbell, transfer_len, intr, lba, opcode);
> +			doorbell, transfer_len, intr, lba, opcode, group_id);
>  }
> 
>  static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 84841b3a7ffd5..50654f3526392 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -11,6 +11,15 @@
> 
>  #include <linux/tracepoint.h>
> 
> +#define str_opcode(opcode)						\
> +	__print_symbolic(opcode,					\
> +		{ WRITE_16,		"WRITE_16" },			\
> +		{ WRITE_10,		"WRITE_10" },			\
> +		{ READ_16,		"READ_16" },			\
> +		{ READ_10,		"READ_10" },			\
> +		{ SYNCHRONIZE_CACHE,	"SYNC" },			\
> +		{ UNMAP,		"UNMAP" })
> +
>  #define UFS_LINK_STATES			\
>  	EM(UIC_LINK_OFF_STATE)		\
>  	EM(UIC_LINK_ACTIVE_STATE)	\
> @@ -215,9 +224,10 @@ DEFINE_EVENT(ufshcd_template, ufshcd_init,
>  TRACE_EVENT(ufshcd_command,
>  	TP_PROTO(const char *dev_name, const char *str, unsigned int tag,
>  			u32 doorbell, int transfer_len, u32 intr, u64 lba,
> -			u8 opcode),
> +			u8 opcode, u8 group_id),
> 
> -	TP_ARGS(dev_name, str, tag, doorbell, transfer_len, intr, lba, 
> opcode),
> +	TP_ARGS(dev_name, str, tag, doorbell, transfer_len,
> +				intr, lba, opcode, group_id),
> 
>  	TP_STRUCT__entry(
>  		__string(dev_name, dev_name)
> @@ -228,6 +238,7 @@ TRACE_EVENT(ufshcd_command,
>  		__field(u32, intr)
>  		__field(u64, lba)
>  		__field(u8, opcode)
> +		__field(u8, group_id)
>  	),
> 
>  	TP_fast_assign(
> @@ -239,13 +250,15 @@ TRACE_EVENT(ufshcd_command,
>  		__entry->intr = intr;
>  		__entry->lba = lba;
>  		__entry->opcode = opcode;
> +		__entry->group_id = group_id;
>  	),
> 
>  	TP_printk(
> -		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 
> 0x%x",
> +		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode:
> 0x%x (%s), group_id: 0x%x",
>  		__get_str(str), __get_str(dev_name), __entry->tag,
>  		__entry->doorbell, __entry->transfer_len,
> -		__entry->intr, __entry->lba, (u32)__entry->opcode
> +		__entry->intr, __entry->lba, (u32)__entry->opcode,
> +		str_opcode(__entry->opcode), (u32)__entry->group_id
>  	)
>  );
