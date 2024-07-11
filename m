Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50EF16C437
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720715244; cv=none; b=TN4FdGCUjKESngcuotbIHvaT162EphiDKP0Mw8U7fePzsrPHBZdsPznSETQnFdccPZzJU3dhCfQL5HSBcQ53QhNdVYqRtvBq1BAqk5yZaqyIZyFTtt5oyaCeGLifwK6pFMrcJpybJVCgo5VfT915ZU/PdmaTj5kPA8OoNeW9eXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720715244; c=relaxed/simple;
	bh=7Npujt/HI+JKoyoMEPQGekvvaq3PC5E7qr0zDHfpoCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dE8F8F8tVHdrg1SawJPad6zcrt2LWYUdOOYEsgGROucR7G+7nYALGcIlaTaiEgb8bAfcP9NuTdFH+2dkHxNqG7p28S8G1dllRM5DLHDxjwiSSNQHxYsiWFiHPTDKNOtM/NU8sOwQ15pyfU9m7r+iMD2/eAcEwQqM201kjgMqnVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=dyD5K72Z; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="dyD5K72Z"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id Rs5vsnEdcg2lzRwddsKC1O; Thu, 11 Jul 2024 16:27:21 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RwdcstG2dks1PRwddsmCSS; Thu, 11 Jul 2024 16:27:21 +0000
X-Authority-Analysis: v=2.4 cv=Ud+aS7SN c=1 sm=1 tr=0 ts=669007e9
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8
 a=RC4BnwySBbfqoxRRKE4A:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=Fp8MccfUoT0GBdDC_Lng:22 a=zSyb8xVVt2t83sZkrLMb:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7RxJ21FjXXoxPmpAMaOPM/NGSLf98n+q9lHoeiSK3rU=; b=dyD5K72ZxHOe6gUh2eDT6OikmS
	HaefSlR5n3lItPNf/YZG8LYP+WW3DhL/VqHZ29sVoI21Rcu+V6bNQzKIhgC5yHr13annwFe9lruDw
	a8NnenPgMuozXZTp0EUiE4V7uYfVkItc5NuEwaKbRycIz8su2FXcL469cWwDgkDaGeiAuwdbaOnSd
	pFD3X8lYPY4bGEUKwQG1X4ddUA2+ivBotRvV5USBr2fkBFOJ5A+RvwG4VSUjFR5RIRHASUHuqxUfr
	JMk2Uv83iPuSHRF225vTQi350Pfh0A9BFDJ3KLkrGxP7yrXpMflTTnwRx0PMkYAejhM/aYTDBdRS1
	OuqoetpA==;
Received: from [201.172.173.139] (port=40030 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRwdc-0006S7-0x;
	Thu, 11 Jul 2024 11:27:20 -0500
Message-ID: <b819d9bd-8b29-4c09-a1f9-f8ec30e4495a@embeddedor.com>
Date: Thu, 11 Jul 2024 10:27:18 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: struct MR_LD_VF_MAP: Replace
 1-element arrays with flexible arrays
To: Kees Cook <kees@kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20240711155823.work.778-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711155823.work.778-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.172.173.139
X-Source-L: No
X-Exim-ID: 1sRwdc-0006S7-0x
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:40030
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 59
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIS34UTDP+GTAlXBJwoxg7DRD94btuVD+DwmKrnUFb8yDUi/G1sGaHyqZN6YR3ZJ5kjXO9AfsBe6MAYTelHta6nh8te6Z9KOibRByaUBBTbBJw8ZOGF+
 Qskm4L3Z1Y2KnMw3uprbO0ZY/gO3+8ZR606FApDVkLHN7vDLJohqq/tQcPLqfpH7D4CdC/mbR3iEWFzFu+WtnJxoFaHn4XZx5FOmgEZqn+G4nGCe6PF7pRUJ



On 11/07/24 09:58, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct MR_LD_VF_MAP with a modern flexible array.
> 
> No binary differences are present after this conversion.
> 
> Link: https://github.com/KSPP/linux/issues/79 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

> ---
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: megaraidlinux.pdl@broadcom.com
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/megaraid/megaraid_sas.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 5680c6cdb221..84cf77c48c0d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2473,7 +2473,7 @@ struct MR_LD_VF_MAP {
>   	union MR_LD_REF ref;
>   	u8 ldVfCount;
>   	u8 reserved[6];
> -	u8 policy[1];
> +	u8 policy[];
>   };
>   
>   struct MR_LD_VF_AFFILIATION {
