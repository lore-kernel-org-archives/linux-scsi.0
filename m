Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC2B3A1E81
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 18:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771958508; cv=none; b=QXZvR+goB+KxL+TgqdgXbru2lSwqpe3Q8y+coHtBAPjr2ed6jGRq0L9jENvRrlwmgWc8gzjQoAHvwIdvBaLf5av72ShFTWyprHkGS5gY1pnbeoojrSx97bPSthJ0qSySl6Oj5LykrwJ0ZKEqVoaxaiWC2gUk43R+ZSTaWrXlAtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771958508; c=relaxed/simple;
	bh=6e0NpjfZmhRjRAKCvu6kZMdRasBBe4nxdRq2eaU1gX8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LZOdbLKwcaEy7D9W3S9GuTnsvEugGyXB1Byq50WEM/GA5emo7ttzZ0/934Qi/1IIudA1t+/GioCeCuF5iFeei1qDxyzuq/D14Qs0KbQzizL/Rutn0wQWjbBzSQHNOx5DZFf4g69vBlyM2kd6bt0qh2w7lsBQ3NbPIufG9WeI6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nqx9Cmpd; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nqx9Cmpd"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771958503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di2K+/lkPw2iD/htfmgecsUtim9xgXXLLRhFeUvIFxg=;
	b=nqx9CmpdnaGagCWHaAfhAbjfxXfSUlhGRn1Bve9H420ioOD99sGvNfs3BohcoQAeyMgYDo
	THsD+hYnQnGr+iJrv34WJHWuIvG1vfnWBXAzSxVT3JBm+cnXrhG7qogHIpvRREQW1kmSK2
	fcxBbiTSj3B7PfGVacyLY3hHlkMlojg=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH RESEND] platform/surface: Replace deprecated strcpy +
 strcat in blogic_rdconfig
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <yq1qzqa80xx.fsf@ca-mkp.ca.oracle.com>
Date: Tue, 24 Feb 2026 19:41:10 +0100
Cc: Khalid Aziz <khalid@gonehiking.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <27B1DB11-A0CE-48CE-9A98-F38E9ACD58D9@linux.dev>
References: <20260224144828.585577-1-thorsten.blum@linux.dev>
 <yq1qzqa80xx.fsf@ca-mkp.ca.oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
X-Migadu-Flow: FLOW_OUT

On 24. Feb 2026, at 19:15, Martin K. Petersen wrote:
>> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> 
> ...and yet tagged as "platform/surface:" in Subject. I fixed it up.

Sorry Martin, no idea how that happened. Thanks for fixing it.

Best,
Thorsten

