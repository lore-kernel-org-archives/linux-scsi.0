Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A979019CCF5;
	Fri, 24 Apr 2026 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776998124; cv=none; b=VQJNa2zaDfHpEt+0qVZDCa1v5OGB/g84Mo76vzztJ+RDTkkXEERFgNDcARJNQ8Jn1kqsOoanYRmBDbfssNaey00O6/5NOopbAtl8/5kz97YYyMLJKd6kRZLeBp4958/1jxibLhyIjuTXWBrbYvp33x8WWo2bEc0ckZs6bzCFwR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776998124; c=relaxed/simple;
	bh=ql9tB+FOewJ/1EnZjjHJLHs0QKWqoKCl2PwWth2civE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgfYiR6kPuvaBhaRVx0oZUKu7uCzYvJLGiB1mnsA9eaiYxx5CAPKknk9hiqnGT4+M55be/S5mTgvsnKvQMsrmtz6LdMbgL7ZIDPaQt0FMCxwa0QUz5frZf2iNnoZhHVMbIXTB2JVmlYXIggCo/MJF69az+8rE95Ay7AyrFEyZQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zo9c7Xz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zo9c7Xz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C08AC2BCAF;
	Fri, 24 Apr 2026 02:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776998124;
	bh=ql9tB+FOewJ/1EnZjjHJLHs0QKWqoKCl2PwWth2civE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zo9c7Xz3sYkyoWGLxP5MP5O0enPxGtzsgAqJz00SIBCtSU/RBfS4J6bqXUM58Lo2+
	 ot0Rdj/ICGVj9UdNxqrTrc5SjkKTwWO4l5Y9W0Th/gL2tKwEeMw8h7jSETnlxkB7Qy
	 znNnow6gMmm3338bxhKM9GbT4g+QCMa9PGWR81vtkXX0zE8Tm9YncJuxyA3SkEAGbq
	 2snqSUoN4BGotlRT6sLKPjeNGDtNa9BdJxmWsMNWxEmgibsijI8xIvV2zb/LIgIXAX
	 UBjrcuzZYmI4qfHnvohQBUmvnRANwJk4rYBgHlbXhQkYU7Ou5PmyL7JrJkfTWbf3MN
	 mmu6fSD25KDzw==
Message-ID: <66414927-481a-4464-8a3d-d6d77ab1aefb@kernel.org>
Date: Fri, 24 Apr 2026 11:35:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: pm8001: add MODULE_AUTHOR entries for new
 contributors
To: Sagar Biradar <sagar.biradar@microchip.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org,
 Don Brace <don.brace@microchip.com>, Raja VS <raja.vs@microchip.com>,
 Kumar Meiyappan <kumar.meiyappan@microchip.com>,
 Abhinav Kuchibhotla <abhinav.kuchibhotla@microchip.com>,
 Uday kumar Bagam <udaykumar.bagam@microchip.com>,
 Advait Churi <advait.churi@microchip.com>
References: <20260421212218.433963-1-sagar.biradar@microchip.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260421212218.433963-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/26 06:22, Sagar Biradar wrote:
> Add MODULE_AUTHOR declarations for the developers who have
> been actively working on the pm8001/pm80xx driver in recent years.
> 
> This helps properly credit the people involved in the ongoing
> maintenance and the current upstreaming effort.
> 
> Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>

Well, if you go there, then you are really missing *a lot* of people.
Just run:

git shortlog -n -s -- drivers/scsi/pm8001

and see the ranking by number of commits.

So in the end, I really do not see the point of this patch since git log can
give a full (and correct) list of contributors.

> ---
>  drivers/scsi/pm8001/pm8001_init.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index e93ea76b565e..487f9bc237ef 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1569,6 +1569,9 @@ MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
>  MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
>  MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
>  MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
> +MODULE_AUTHOR("Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>");
> +MODULE_AUTHOR("Kumar Meiyappan <Kumar.Meiyappan@microchip.com>");
> +MODULE_AUTHOR("Sagar Biradar <Sagar.Biradar@microchip.com>");
>  MODULE_DESCRIPTION(
>  		"PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077/8070/8072 "
>  		"SAS/SATA controller driver");


-- 
Damien Le Moal
Western Digital Research
