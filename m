Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i417pWlz"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A4B9A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 10:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701888955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrcQ95ZMuKjHuke9HbkHyZcFozNRKymXYXIu9pIY1jA=;
	b=i417pWlz4AWa5xAzY+a5muZbBDvk89e9GOsXeVBkQiMptkT7ZTwIpYQ34fFMPNaaZeFdnL
	bfnFC9Cc77glXCKYnWCgzcNBIpYcxAtkXiZTALMYujBHcIcLNI444SsO/yoJ5kTcbQsF1+
	jtmB5R1q6Uw4rzr+xcnD6U0NY1QYgI8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-ICt2jdPqOJC789jbpo6Djw-1; Wed, 06 Dec 2023 13:54:46 -0500
X-MC-Unique: ICt2jdPqOJC789jbpo6Djw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67ab4382912so3503986d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888886; x=1702493686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrcQ95ZMuKjHuke9HbkHyZcFozNRKymXYXIu9pIY1jA=;
        b=ZFtmoOdbQQetF9QWR8d+cbEo8oPBDmw940JHFsaAUQZiVysK4pKrM3k/EjGfdmuLRR
         6WTVSAj45LcIfeZj70ILvo+aiBHbbaQ4U4Ltf6ZWE8tgKx9J40ykzG6SgTms/FAdFHLs
         6LgAMnaqDGqLgotsMjP+mTeyZ90CT7Ds4/+pjV3p18P+2JRL/yB/MeJx4GeyF003eFi2
         IWBobY4x3Cp25og2h3FrMvGIIS9nHaVubyoSudtbK51/Diwpf1YqdufGHcClPjCG2I24
         hJx7SN+Om9dcIvkraukwTUF77Qcztu5BVb+YtJQWhuagt1J6IbEs+pILo6s8bqWcQ2Pz
         /YDA==
X-Gm-Message-State: AOJu0YyZoBoWryoc6YLlgpOSYstPSSwwPbTH4ecAOqQ5wO4zC1GyMn3C
	gHF3KlIllTWQCRfn/16R/piQBYGa1Uk42re+RSI8EP09+QS1Mhkx/RZe/Xhqv5vbucBdd2Wn2+6
	sOIjpUUwjyXO73lnsY4vgkQ==
X-Received: by 2002:a0c:c310:0:b0:67a:bde:8898 with SMTP id f16-20020a0cc310000000b0067a0bde8898mr2144619qvi.5.1701888886171;
        Wed, 06 Dec 2023 10:54:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGD8g0owuNThJQurdEIVWL455BacG+Ujo4HaFTS7u/XHSiv+qtGjLbdu2sMVZi4/hyaNg5viw==
X-Received: by 2002:a0c:c310:0:b0:67a:bde:8898 with SMTP id f16-20020a0cc310000000b0067a0bde8898mr2144601qvi.5.1701888885946;
        Wed, 06 Dec 2023 10:54:45 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id qd19-20020a05620a659300b0077d8a162babsm167867qkn.13.2023.12.06.10.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:54:45 -0800 (PST)
Date: Wed, 6 Dec 2023 12:54:43 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 11/13] scsi: ufs: qcom: Remove unused ufs_qcom_hosts
 struct array
Message-ID: <sqdgnfedt5j3epypmsvb7lv6gvmjrymtuieji3yhqsfvniiodl@f3aj73mlshxy>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-12-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-12-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:15PM +0530, Manivannan Sadhasivam wrote:
> ufs_qcom_hosts array is assigned, but not used anywhere. So let's remove
> it.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/ufs/host/ufs-qcom.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index a86f6620abc8..824c006be093 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -90,8 +90,6 @@ static const struct __ufs_qcom_bw_table {
>  	[MODE_MAX][0][0]		    = { 7643136,	307200 },
>  };
>  
> -static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
> -

I think we can get rid of MAX_UFS_QCOM_HOSTS as well with this change in
place?

>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
>  static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up);
>  
> @@ -1192,9 +1190,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  
>  	ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
>  
> -	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
> -		ufs_qcom_hosts[hba->dev->id] = host;
> -
>  	ufs_qcom_get_default_testbus_cfg(host);
>  	err = ufs_qcom_testbus_config(host);
>  	if (err)
> -- 
> 2.25.1
> 
> 

