Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2F61FE451;
	Mon, 11 Aug 2025 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754899296; cv=none; b=FErWbJxjmNzVaj0N2meUObvzyvzXekXOEhfnv+iIGKO6waeOVn5qW5Xp3wtBcNWGn6Y3VrPgXIsheEbKVLmlKMd0Ty1zHDrGPniDXMFf9/367Rs1Ln78ntIDeJHd9Av74c0RCLQLCu/71QqnIxV8lWgQpjjhsx23hezhqdYqRUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754899296; c=relaxed/simple;
	bh=0JyXYXb9KFtCU8BzpWHuC7G+pxNfzDxCizbDh/SkI/o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=psC3S4j/9KS0eJbWlEDnp2Z+3KHoUVhiMs007vPHhYERaPnsbhAfvg1hO6wPDkht5BgK4ZU6veOcT9QVcyBJpez5oK44J4bmBXVoejthfn8A/LfFubxdHRjApU849hEfBXpng8rgzT2DWkuGQn9yyGPOAIPCyPII4mKBvx3AS0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=aIw++hJL; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="aIw++hJL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1754899243; x=1755504043; i=markus.elfring@web.de;
	bh=aKaiW5eywj05zLSL70x4dRdH0RtSj6BDlVRQ1gRnWCM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=aIw++hJLAMhEnqTLgo7AK9euO8U59z+wTSwSjju9Cmxi75Hnw9FL1KJ6vqUzU5j7
	 zbA3+LkSHRrpf5ISuSghOSTiBz8CcJOWLG9Gum9ITbWnmXiDhzLSiCZzv5TknaKNK
	 94RJKBiYzUbM/AMe41ysb2yhF4AR6DzcMRCO4/FVBs/R8pmai8uVB6gsUAR0pVB5p
	 Dvc3QlX0m+FoNpZq4w0qd9ghqqXq+wIExp5/DUPvU0ys4mhKlkGhGnXVWnIfefqSW
	 wTBya+fR8VLuMiqUGaHkBrWmFN8cR5w/lS/z6PfaXN78/7Ro+jhxqY99CoAab2/c8
	 NETOGxXjjw8iS1JZ/w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.213]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N3Xjb-1uckOG0U5r-00tZNM; Mon, 11
 Aug 2025 10:00:43 +0200
Message-ID: <7c7aedbf-389d-4e5a-83d0-33c51cda1d8a@web.de>
Date: Mon, 11 Aug 2025 10:00:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Shivani Agarwal <shivani.agarwal@broadcom.com>,
 Sasha Levin <sashal@kernel.org>, Viswas G <Viswas.G@microchip.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Ajish Koshy <Ajish.Koshy@microchip.com>, Jack Wang <jinpu.wang@ionos.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com, stable@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Tapas Kundu <tapas.kundu@broadcom.com>
References: <20250811052035.145021-1-shivani.agarwal@broadcom.com>
Subject: Re: [PATCH v5.10] scsi: pm80xx: Fix memory leak during rmmod
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250811052035.145021-1-shivani.agarwal@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NNkzAAUaSKDfGikxHGlUy3z99Kpc3+L+T9HTNfok57D+Sbcoqbd
 7k+ILh7L4/N13ut3HnHtXq7ffkKLo32kQz4esoCsaOCuFheMmF/VK4BQZD1vXXVlpRWBzWE
 s8LkempUdbPAqaH3y/lhLVOboP3HC6KuNm+OYsiccz1f+wMXMTPSaurcY0QCo7BbRCEzEED
 W7DiFhvSaUXpglPEGSADw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xdpwiihKzBQ=;gmk+iyXzkC0v0ETOoAOGAVA2IEO
 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

=E2=80=A6
> +++ b/drivers/scsi/pm8001/pm8001_init.c
=E2=80=A6
> @@ -1226,6 +1227,16 @@ static void pm8001_pci_remove(struct pci_dev *pde=
v)
>  			tasklet_kill(&pm8001_ha->tasklet[j]);
>  #endif
>  	scsi_host_put(pm8001_ha->shost);
> +
> +	for (i =3D 0; i < pm8001_ha->ccb_count; i++) {
> +		dma_free_coherent(&pm8001_ha->pdev->dev,
> +			sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
> +			pm8001_ha->ccb_info[i].buf_prd,
> +			pm8001_ha->ccb_info[i].ccb_dma_handle);
> +	}

May curly brackets be omitted here?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.16#n197

Regards,
Markus
