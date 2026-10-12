Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854DE4A64CF;
	Mon, 12 Oct 2026 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820110; cv=none; b=aDbNFfTUeZ8B7mAjg57aqTgSbsu8j7dmMqo2dLw7inG30NGRHw58kH62vjfmhnmD0Ev0L23D1zoSND4BjkaB7UCzElutbU4swBOIKbSgD7CzcTZZ9TquiBBcjDsqc2VeWY9L8SxGucz19KW2dZtRF4HFrvhqYmAide9aJTOWUGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820110; c=relaxed/simple;
	bh=HtbVrjjLMejF1IvB3Efu9JWPiM87tU4Y34khsHLXIMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YPuBkCbLxYkWczQIZRanFKZKunWnjekjFj78oLYxx6+UineyrAgItZd4EgNh2KlwpDsuyxmWSe6PZtXOYuuSjAN6VmagGwPbNZisQL0CHagQ+73eUdBMCx2TJ10UROPD3KNUm6LHrq8zJqFOZa4Hk8JKoBfFaT2xn0Azu0NjG4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=HtSkVJQB; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="HtSkVJQB"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4j3MLx4R3Nz4LSk;
	Mon, 12 Oct 2026 17:48:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1791820105;
	bh=HtbVrjjLMejF1IvB3Efu9JWPiM87tU4Y34khsHLXIMs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HtSkVJQB32a6jkG/B+AGdDte7SFLq9oXwEKHN8sWg0TyZTbTM+zp+64adkwkKGjIv
	 15+E/1M7NY9EcW5hlwK1rtmlHvNABkPMB8Zds7C+19hfymWdDAeaRs7Qf73zYkc7ZZ
	 L9zDffGu32x3NMpnVRLUZabDvrrTl3eIqIyJbsUe005lhY1Ve4x5PW91SDhSqZ8z0w
	 Ojz6SCQQXrloUeSn4PM8Gfu2U+MjcHO74jDTKvMoVCa516nA8U+dGlzO8tykjkFgZN
	 izkvxXRjlkNRzr+ZJAigQPy8waER1YEOLXYNReYoO+KuAV6gW7pECABLYDjM3XUuv9
	 7TiCJjIq/cJDw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4j3MLx3jzGz4LSV;
	Mon, 12 Oct 2026 17:48:25 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4j3MLw5F5pz8svT;
	Mon, 12 Oct 2026 17:48:24 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id C1CFC5FA0A;
	Mon, 12 Oct 2026 17:48:19 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <111e94e9-79c9-48f2-8976-70470e59b89d@leemhuis.info>
Date: Mon, 12 Oct 2026 17:48:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: use DevicePage0 link rate only for
 direct-attached targets
To: Ilya Khomyakov <khomyakovilya@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com, regressions@lists.linux.dev,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260804142800.4326-1-khomyakovilya@gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <20260804142800.4326-1-khomyakovilya@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <179182010029.914747.2425492917080082038@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: C1CFC5FA0A
X-NC-CID: 0mnVUIfrul6zl9ZaOjksub9GAqSmtleBgE4Qx8o7TmpDi+DTQ4I=

On 8/4/26 16:28, Ilya Khomyakov wrote:
> This patch fixes a regression in the Broadcom MPI3 Storage Controller
> driver under drivers/scsi/mpi3mr/.

Ilya, what's the status of this regression fix? It looks like it fall
through the cracks. Or was there some progress that I missed (which can
easily happen!)

Ciao, Thorsten
> Commit c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from
> DevicePage0") changed mpi3mr to prefer the cached DevicePage0 rate.
> 
> DevicePage0 stores negotiated_link_rate as one standalone MPI3 SAS
> link-rate code, while SAS PHY Page 0 and SAS Expander Page 1 store logical
> and physical rates as two nibbles of one packed byte.
> 
> mpi3mr_get_sas_negotiated_logical_linkrate() currently sends both formats
> through the same high-nibble extraction at its common exit. A valid
> DevicePage0 value of 0x0b or 0x0c is therefore converted to zero. The later
> minimum-rate safeguard then publishes the value as 1.5 Gbit/s.
> 
> For example:
> 
>   DevicePage0 value:            0x0b
>   packed-field extraction:      (0x0b & 0xf0) >> 4 = 0x00
>   minimum-rate substitution:    0x00 -> 0x08
>   Linux SAS transport result:   1.5 Gbit/s
> 
> There is also a topology distinction. The caller uses the returned value to
> update the parent sas_phy. In an expander topology with the HBA-to-expander
> link limited to 12 Gbit/s, DevicePage0 reported 0x0b for every tested
> target, while Expander Page 1 reported 0xcc for several disk-facing PHYs
> that were operating at 22.5 Gbit/s. The cached target value therefore
> cannot unconditionally replace the local parent expander PHY value.
> 
> The original failure was reproduced on an eHBA 9600 controller with a
> SAS4016 IOC and a 46-PHY Microchip expander. Before the fix, a target with
> DevicePage0 negotiated_link_rate 0x0b could remain visible in sysfs as
> 1.5 Gbit/s when a replayed topology event contained current=0x0b and
> previous=0x0b and therefore skipped the Linux-side update.
> 
> Validate the standalone DevicePage0 code and use it directly only for a
> directly attached target. For an expander-attached target, retain the
> existing Expander Page 1 path because it describes the local parent
> expander PHY being updated. Retain the SAS PHY Page 0 fallback when a
> directly attached cached value is invalid.
> 
> The topology-aware variant was tested in an out-of-tree mpi3mr 8.17.1.0.
> build. After boot, Linux reported:
> 
>   PHY 18: 12.0 Gbit/s
>   PHY 19: 12.0 Gbit/s
>   PHY 24: 22.5 Gbit/s
>   PHY 25: 22.5 Gbit/s
>   PHY 26: 22.5 Gbit/s
>   PHY 27: 22.5 Gbit/s
>   PHY 28: 12.0 Gbit/s
>   PHY 30: 22.5 Gbit/s
> 
> No tested PHY was incorrectly reported as 1.5 Gbit/s, and the 22.5 Gbit/s
> disk-facing rates were preserved even though DevicePage0 contained 0x0b.
> 
> Fixes: c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from DevicePage0")
> Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>
> 
> ---
>  drivers/scsi/mpi3mr/mpi3mr_transport.c | 46 ++++++++++++++++++++++----
>  1 file changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> index 240f67a..740fccc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -587,6 +587,30 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
>  	return rc;
>  }
>  
> +/**
> + * mpi3mr_sas_link_rate_valid - validate a standalone SAS link-rate code
> + * @link_rate: MPI3 standalone SAS negotiated link-rate code
> + *
> + * DevicePage0 stores one plain negotiated link-rate code. Accept only
> + * negotiated data rates supported by the SAS transport conversion code;
> + * reserved or transitional values must use the existing PHY-page path.
> + *
> + * Return: true for a supported negotiated data rate, false otherwise.
> + */
> +static bool mpi3mr_sas_link_rate_valid(u8 link_rate)
> +{
> +	switch (link_rate) {
> +	case MPI3_SAS_NEG_LINK_RATE_1_5:
> +	case MPI3_SAS_NEG_LINK_RATE_3_0:
> +	case MPI3_SAS_NEG_LINK_RATE_6_0:
> +	case MPI3_SAS_NEG_LINK_RATE_12_0:
> +	case MPI3_SAS_NEG_LINK_RATE_22_5:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /**
>   * mpi3mr_delete_sas_phy - Remove a single phy from port
>   * @mrioc: Adapter instance reference
> @@ -2292,18 +2316,26 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
>  static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
>  	struct mpi3mr_tgt_dev *tgtdev)
>  {
> -	u8 link_rate = MPI3_SAS_NEG_LINK_RATE_1_5, phy_number;
> +	u8 cached_link_rate, link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
> +	u8 phy_number;
>  	struct mpi3_sas_expander_page1 expander_pg1;
>  	struct mpi3_sas_phy_page0 phy_pg0;
>  	u32 phynum_handle;
>  	u16 ioc_status;
>  
> -	/* First, try to use link rate from DevicePage0 (populated by firmware) */
> -	if (tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate >=
> -	    MPI3_SAS_NEG_LINK_RATE_1_5) {
> -		link_rate = tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
> -		goto out;
> -	}
> +	cached_link_rate =
> +		tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
> +
> +	/*
> +	 * For a directly attached target, DevicePage0 and the parent host PHY
> +	 * describe the same link, so the standalone cached code can be used
> +	 * without packed-field decoding. For an expander-attached target, the
> +	 * caller updates the parent expander PHY and DevicePage0 can differ from
> +	 * that local segment; retain the Expander Page 1 read in that case.
> +	 */
> +	if ((tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED) &&
> +	    mpi3mr_sas_link_rate_valid(cached_link_rate))
> +		return cached_link_rate;
>  
>  	/* Fallback to reading from phy pages if DevicePage0 value not available */
>  	phy_number = tgtdev->dev_spec.sas_sata_inf.phy_id;

