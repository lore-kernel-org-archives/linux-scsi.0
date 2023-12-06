Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYyZu2yl"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412B6D44
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 10:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701887122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KTobgsnYUuUSJ3+JcdTWkz3Ys2jB6Jq/YKHe84U3RGg=;
	b=dYyZu2ylGpbJyuFaghFHERFW5gC/elYZwSQ+4CVAhk/QpwbuaSf+yJ0zYEagFORBBBQrFB
	cueiEw9XxQQf7MvQubnTFjiTVHM0QzPHlXT6+ObwmOviZdGffDC4IciNei1CuoYrYxBve/
	jXzIp5Xb69hGinQkT0sEAz8qw/7L0+c=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-RGxpfz-ZNASZ25z_XqqqDA-1; Wed, 06 Dec 2023 13:15:59 -0500
X-MC-Unique: RGxpfz-ZNASZ25z_XqqqDA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-423afeb1cbcso368801cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:15:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701886549; x=1702491349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTobgsnYUuUSJ3+JcdTWkz3Ys2jB6Jq/YKHe84U3RGg=;
        b=P34FGZrIWYWAHJvaKmhrtgDCwjoh2t4li62k3f7U2/fki4fm6mrpppA/omAFQWGg1F
         /hupwlhMBpbixICLntfoyQa+9WGFPHtgGThY3knDC4JyAUzgNDqrQWTnH/7369es0xjn
         gh4ZokxajdAqYwva2yw6gb+X7p+q1JT1e3CQV5pJ+OivJMXudQadjVT2m/guiYenUaVI
         KKeOtPsCUVgSW2vaM7m7CK5acky81iDg2qKR10jECCS4MVHGY/zOvpF4i4kDpBg5U2il
         94/VqbSNGSEbDJPUTW+a+mly6UlocQV0w4EYB466KNUvr9LqZsGoWHaeLyMVWvkuNsjA
         VOIw==
X-Gm-Message-State: AOJu0Yze8t8AT0EuxDq7PkSQA5b6apokMCXfUcsorYr0C6hOr80rsysu
	q9OhFjXoGm4CAr8sIEazc3W+UEsB32Jlt205iOyOwbKcNG6xEIo7wIfnm+AFyu/Ov2XWxm2kDD0
	xmNIM+MENvQVoGXgc7YcwxQ==
X-Received: by 2002:a05:622a:1c7:b0:425:4043:1daf with SMTP id t7-20020a05622a01c700b0042540431dafmr1590225qtw.130.1701886548808;
        Wed, 06 Dec 2023 10:15:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYXmE8oxD/ljT+fjjqAZa2L1Mek9Kw87+1sXy5PKCDiHvI+RdUhoxjbWV8Mvzl4SX522xqJg==
X-Received: by 2002:a05:622a:1c7:b0:425:4043:1daf with SMTP id t7-20020a05622a01c700b0042540431dafmr1590209qtw.130.1701886548556;
        Wed, 06 Dec 2023 10:15:48 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id d20-20020ac85454000000b00423dfab8fc3sm140297qtq.32.2023.12.06.10.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:15:48 -0800 (PST)
Date: Wed, 6 Dec 2023 12:15:46 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 04/13] scsi: ufs: qcom: Remove superfluous variable
 assignments
Message-ID: <lpon5atd74luwzrnzh2imc3h7e7hvdn4nopi6ocw7uvzw72dgr@llure3vkleru>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-5-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-5-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:08PM +0530, Manivannan Sadhasivam wrote:
> There are many instances where the variable assignments are not needed.
> Remove them.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 778df0a9c65e..dc93b1c5ca74 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -219,7 +219,7 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
>  
>  static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>  {
> -	int err = 0;
> +	int err;
>  	struct device *dev = host->hba->dev;
>  
>  	if (has_acpi_companion(dev))
> @@ -237,7 +237,7 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>  static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>  {
>  	int err;
> -	u32 tx_fsm_val = 0;
> +	u32 tx_fsm_val;
>  	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>  
>  	do {
> @@ -292,9 +292,9 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>   */
>  static int ufs_qcom_host_reset(struct ufs_hba *hba)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	bool reenable_intr = false;
> +	bool reenable_intr;
>  
>  	if (!host->core_reset) {
>  		dev_warn(hba->dev, "%s: reset control not set\n", __func__);
> @@ -417,7 +417,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>  				      enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	int err = 0;
> +	int err;
>  
>  	switch (status) {
>  	case PRE_CHANGE:
> @@ -463,7 +463,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
>  	u32 core_clk_period_in_ns;
>  	u32 tx_clk_cycles_per_us = 0;
>  	unsigned long core_clk_rate = 0;
> -	u32 core_clk_cycles_per_us = 0;
> +	u32 core_clk_cycles_per_us;
>  
>  	static u32 pwm_fr_table[][2] = {
>  		{UFS_PWM_G1, 0x1},
> @@ -1418,7 +1418,7 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
>  		bool scale_up, enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	int err = 0;
> +	int err;
>  
>  	/* check the host controller state before sending hibern8 cmd */
>  	if (!ufshcd_is_hba_active(hba))
> @@ -1689,7 +1689,7 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>  	struct platform_device *pdev = to_platform_device(hba->dev);
>  	struct ufshcd_res_info *res;
>  	struct resource *res_mem, *res_mcq;
> -	int i, ret = 0;
> +	int i, ret;
>  
>  	memcpy(hba->res, ufs_res_info, sizeof(ufs_res_info));
>  
> -- 
> 2.25.1
> 
> 

