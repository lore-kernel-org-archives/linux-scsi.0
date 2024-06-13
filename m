Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C20C137901;
	Thu, 13 Jun 2024 06:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261507; cv=none; b=SUns7/sSkJeXbU/9PxIZ/m9osvHhVx6Mt5U7yjBxBjR2tBMcSkZmwIlURWxF2mgY5IPnIfTZXjQ4eV00U2fWpNXFVa2hLRD6fqQBBikEoYmOUVCVRxm+b4XYzZmU1gGox2dpLciE0DLcgHI38jk3+Raui1IYYgp8y5gXC/Z5yRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261507; c=relaxed/simple;
	bh=DISS2YwDQPYa7mVcT0lvbzeHiuRYqcTkaffTsBkSSe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MajEPE6Yn4OJb7QjqF50vjlZPbHqsb9oYWd1fgBah0dY+Hn8CHhDjkf+XAASQUMwKxuDe5vTOcqQi600TEVwJF9972CLx2ZpMAJMRp42FGpRJuVPLIJ08bcRw8eiQ+Jw6G8J9zPKqFwEmF/Ygpy6JchNjuVoFFt9a6XI9CIRWbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e51ce8d6294c11ef9305a59a3cc225df-20240613
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:822aa32b-5aae-44ac-9eb3-141eff61a691,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:11
X-CID-INFO: VERSION:1.1.38,REQID:822aa32b-5aae-44ac-9eb3-141eff61a691,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:11
X-CID-META: VersionHash:82c5f88,CLOUDID:279137cffa3aae4917c866d49c9022f9,BulkI
	D:240613141932DQLUDI5I,BulkQuantity:0,Recheck:0,SF:19|44|64|66|24|72|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR
X-UUID: e51ce8d6294c11ef9305a59a3cc225df-20240613
Received: from node2.com.cn [(39.156.73.10)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1081659897; Thu, 13 Jun 2024 14:19:30 +0800
Received: from node2.com.cn (localhost [127.0.0.1])
	by node2.com.cn (NSMail) with SMTP id A2299B80758A;
	Thu, 13 Jun 2024 14:19:30 +0800 (CST)
X-ns-mid: postfix-666A8F72-56615134
Received: from [172.30.60.81] (unknown [172.30.60.81])
	by node2.com.cn (NSMail) with ESMTPA id 1E660B80758A;
	Thu, 13 Jun 2024 06:19:29 +0000 (UTC)
Message-ID: <453a31c7-cae1-48cd-9f61-1faa78988597@kylinos.cn>
Date: Thu, 13 Jun 2024 14:19:29 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: megaraid_sas: Add megasas_dcmd_timeout helper
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
 shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com
Cc: liuyun01@kylinos.cn, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, geliang@kernel.org
References: <20240530094514.2750723-1-mengfanhui@kylinos.cn>
 <20240530094514.2750723-2-mengfanhui@kylinos.cn>
Content-Language: en-US
From: mengfanhui <mengfanhui@kylinos.cn>
In-Reply-To: <20240530094514.2750723-2-mengfanhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Can someone help review it? Thank you!

=E5=9C=A8 2024/5/30 17:45, mengfanhui =E5=86=99=E9=81=93:
> DCMD timeout is handled in many places, it makes sense to
> add a hepler to handle it. This patch adds a new helper
> named megasas_dcmd_timeout() to reduce duplicate code.
>=20
> Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: mengfanhui <mengfanhui@kylinos.cn>
> Suggested-by: Geliang Tang <geliang@kernel.org>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |   2 +
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 199 ++++----------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  34 +---
>  3 files changed, 38 insertions(+), 197 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megara=
id/megaraid_sas.h
> index 91570c5e8456..d96dc446c3aa 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2761,5 +2761,7 @@ void megasas_setup_debugfs(struct megasas_instanc=
e *instance);
>  void megasas_destroy_debugfs(struct megasas_instance *instance);
>  int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_nu=
m);
>  int dcmd_timeout_ocr_possible(struct megasas_instance *instance);
> +void megasas_dcmd_timeout(struct megasas_instance *instance,
> +			struct megasas_cmd *cmd);
> =20
>  #endif				/*LSI_MEGARAID_SAS_H */
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
> index ba8061ea2078..9325a011746d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4531,6 +4531,30 @@ int dcmd_timeout_ocr_possible(struct megasas_ins=
tance *instance)
>  		return INITIATE_OCR;
>  }
> =20
> +/*
> + * megasas_dcmd_timeout -	Classification processing dcmd timeout.
> + * @instance:				Adapter soft state
> + */
> +void megasas_dcmd_timeout(struct megasas_instance *instance, struct me=
gasas_cmd *cmd)
> +{
> +	switch (dcmd_timeout_ocr_possible(instance)) {
> +	case INITIATE_OCR:
> +		cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> +		mutex_unlock(&instance->reset_mutex);
> +		megasas_reset_fusion(instance->host,
> +					MFI_IO_TIMEOUT_OCR);
> +		mutex_lock(&instance->reset_mutex);
> +		break;
> +	case KILL_ADAPTER:
> +		megaraid_sas_kill_hba(instance);
> +		break;
> +	case IGNORE_TIMEOUT:
> +		dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> +			__func__, __LINE__);
> +		break;
> +	}
> +}
> +
>  static void
>  megasas_get_pd_info(struct megasas_instance *instance, struct scsi_dev=
ice *sdev)
>  {
> @@ -4582,24 +4606,7 @@ megasas_get_pd_info(struct megasas_instance *ins=
tance, struct scsi_device *sdev)
>  		break;
> =20
>  	case DCMD_TIMEOUT:
> -
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -				MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				__func__, __LINE__);
> -			break;
> -		}
> -
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
>  	}
> =20
> @@ -4678,29 +4685,7 @@ megasas_get_pd_list(struct megasas_instance *ins=
tance)
>  			instance->pd_list_not_supported =3D 1;
>  		break;
>  	case DCMD_TIMEOUT:
> -
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			/*
> -			 * DCMD failed from AEN path.
> -			 * AEN path already hold reset_mutex to avoid PCI access
> -			 * while OCR is in progress.
> -			 */
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -						MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d \n",
> -				__func__, __LINE__);
> -			break;
> -		}
> -
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
> =20
>  	case DCMD_SUCCESS:
> @@ -4805,29 +4790,7 @@ megasas_get_ld_list(struct megasas_instance *ins=
tance)
>  		megaraid_sas_kill_hba(instance);
>  		break;
>  	case DCMD_TIMEOUT:
> -
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			/*
> -			 * DCMD failed from AEN path.
> -			 * AEN path already hold reset_mutex to avoid PCI access
> -			 * while OCR is in progress.
> -			 */
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -						MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				__func__, __LINE__);
> -			break;
> -		}
> -
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
> =20
>  	case DCMD_SUCCESS:
> @@ -4925,28 +4888,7 @@ megasas_ld_list_query(struct megasas_instance *i=
nstance, u8 query_type)
>  		ret =3D megasas_get_ld_list(instance);
>  		break;
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			/*
> -			 * DCMD failed from AEN path.
> -			 * AEN path already hold reset_mutex to avoid PCI access
> -			 * while OCR is in progress.
> -			 */
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -						MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				__func__, __LINE__);
> -			break;
> -		}
> -
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
>  	case DCMD_SUCCESS:
>  		tgtid_count =3D le32_to_cpu(ci->count);
> @@ -5081,22 +5023,7 @@ megasas_host_device_list_query(struct megasas_in=
stance *instance,
>  		break;
> =20
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -				MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				 __func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
>  	case DCMD_FAILED:
>  		dev_err(&instance->pdev->dev,
> @@ -5232,22 +5159,7 @@ void megasas_get_snapdump_properties(struct mega=
sas_instance *instance)
>  		break;
> =20
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -				MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				__func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
>  	}
> =20
>  	if (ret !=3D DCMD_TIMEOUT)
> @@ -5372,22 +5284,7 @@ megasas_get_ctrl_info(struct megasas_instance *i=
nstance)
>  		break;
> =20
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -				MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				__func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
>  	case DCMD_FAILED:
>  		megaraid_sas_kill_hba(instance);
> @@ -5454,20 +5351,8 @@ int megasas_set_crash_dump_params(struct megasas=
_instance *instance,
>  		ret =3D megasas_issue_polled(instance, cmd);
> =20
>  	if (ret =3D=3D DCMD_TIMEOUT) {
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			megasas_reset_fusion(instance->host,
> -					MFI_IO_TIMEOUT_OCR);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				__func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
> +
>  	} else
>  		megasas_return_cmd(instance, cmd);
> =20
> @@ -6840,23 +6725,7 @@ megasas_get_target_prop(struct megasas_instance =
*instance,
> =20
>  	switch (ret) {
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -					     MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev,
> -				 "Ignore DCMD timeout: %s %d\n",
> -				 __func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
> =20
>  	default:
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi=
/megaraid/megaraid_sas_fusion.c
> index f0aeb1ee83a2..1d0991650062 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1371,22 +1371,7 @@ megasas_sync_pd_seq_num(struct megasas_instance =
*instance, bool pend) {
>  		instance->pd_seq_map_id++;
>  		break;
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -					     MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				 __func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
>  	case DCMD_FAILED:
>  		dev_err(&instance->pdev->dev,
> @@ -1476,22 +1461,7 @@ megasas_get_ld_map_info(struct megasas_instance =
*instance)
> =20
>  	switch (ret) {
>  	case DCMD_TIMEOUT:
> -		switch (dcmd_timeout_ocr_possible(instance)) {
> -		case INITIATE_OCR:
> -			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
> -			mutex_unlock(&instance->reset_mutex);
> -			megasas_reset_fusion(instance->host,
> -					     MFI_IO_TIMEOUT_OCR);
> -			mutex_lock(&instance->reset_mutex);
> -			break;
> -		case KILL_ADAPTER:
> -			megaraid_sas_kill_hba(instance);
> -			break;
> -		case IGNORE_TIMEOUT:
> -			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> -				 __func__, __LINE__);
> -			break;
> -		}
> +		megasas_dcmd_timeout(instance, cmd);
>  		break;
>  	case DCMD_FAILED:
>  		dev_err(&instance->pdev->dev,
