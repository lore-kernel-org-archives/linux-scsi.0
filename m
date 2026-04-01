Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139663F7E93;
	Wed,  1 Apr 2026 12:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046549; cv=none; b=XnLd6OjYZG9rUMgXXxLblD8f/vbcod8qPGXLTE98exnLI5BJ90jm4R6KnQh9bPBpZQIYmONiMi1rT5OqNvZjWJBIaQ7DfJ1bu9Tmh1jNu0BzK91roxZsfrI+raAkGgeul+efIXMzQWzg95CvmJllFW67tc+N2KzNear+JpTy2KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046549; c=relaxed/simple;
	bh=NvgNkEMAN52LEQ4N0hlij8TYcV+8I2cZgNeTB7K/fJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxQ5KWvO3vQOpnx+XmSwt3ZLpW5OIHhhXFkRXNrj5XZb6lYRabRkaw+HdB+cDlOiXZn5imsmcpFXpBc5BZn2jsKygEyMbZhDUnM++3l9xJKov3Ni3AfVD6poD1Dmt1d+YGkrAlt9bVsoMqez+qS+feF/mzI4CBMau8/goZtCrVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8A3xcAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8A3xcAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36036C4CEF7;
	Wed,  1 Apr 2026 12:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775046548;
	bh=NvgNkEMAN52LEQ4N0hlij8TYcV+8I2cZgNeTB7K/fJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I8A3xcAp19J7C3Xq7hDDhs29w1fBgvrJxUzMTiATHfo83y6qixx/OtOlIz4gsNNlV
	 t9kI+WT9osbrw3iPmqkHIYOCwn/ebzfsLhlrfPaXFUn/oW1KSUjkxUVeOTPwtsTlPw
	 2UiLE0tfsSfbsVQMNC2mVZ0cMMZlOUdj2onG7DfhFbvSs0MloXFTNnQ/h8pXwmWWIl
	 8ZJvkdtZeh06N9R1OUQd0tcEy5NNXfT8OoW+0al4pVaDhuqanGENKddGYG4ezBf0cm
	 FgOOEyWAJ3f4fUF9T/4v1o1FeLGvElNCB5BPc0ucot+PO53jgRnUu0PWDVz/oNzGE9
	 idVNg2ikk+cYQ==
Date: Wed, 1 Apr 2026 17:59:01 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: ufs-qcom: Fix spelling mistake "retore"
 -> "restore"
Message-ID: <sfyaonr2izg2xynwuwh7xvxvn4jmml7talyp2ntx3asv3eoujq@ryi6p6sliwam>
References: <20260331153049.1344957-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260331153049.1344957-1-colin.i.king@gmail.com>

On Tue, Mar 31, 2026 at 04:30:49PM +0100, Colin Ian King wrote:
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 5a58ffef3d27..bc037db46624 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2810,7 +2810,7 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>  	/* Restore Power Mode. */
>  	ret = ufshcd_change_power_mode(hba, &old_pwr_info, UFSHCD_PMC_POLICY_FORCE);
>  	if (ret) {
> -		dev_err(hba->dev, "%s: Failed to retore power mode to HS-G%u: %d\n",
> +		dev_err(hba->dev, "%s: Failed to restore power mode to HS-G%u: %d\n",
>  			__func__, old_pwr_info.gear_tx, ret);
>  		return ret;
>  	}
> -- 
> 2.53.0
> 

-- 
மணிவண்ணன் சதாசிவம்
