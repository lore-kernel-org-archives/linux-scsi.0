Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB15B3859EE;
	Tue, 18 Aug 2026 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067590; cv=none; b=QL2IBMFNz/UAuQAdGC/t+Av4jp8pWn7GvHEC+qTYCLNfmm9bBIs3ajJTjY3kc7+Nw5NabRNlCGFhb3g4B979gTWMGaXn0jESPAwBVTWrVP0VuT6ttEbKtp28k6o+UGOgZKr0482Q9+VzW31Ds5fKw1VpiDVo6pnddmBHkEKk8jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067590; c=relaxed/simple;
	bh=BNiHyzbsqu8DU6QeX+WLcPfqdvQM7D/y2S8hVIpdx78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhI9RJVevTFad2QNHV/Vs5EdlQJux674/f344U2+TREH7hR777SVm+d/GKYZo8bLGpbTyUdkx3lgDK2UQ9YwZImIM4RStv+7kTu+VBL35ol73nKmU7LpEhRFBRbETKcq62icPWKuvIp/xz6rMyIM8JKT99w77NMm/xE+YfbH+PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0CPpVijc; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0CPpVijc"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hPYmM62c7zlfvq4;
	Tue, 18 Aug 2026 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787067585; x=1789659586; bh=BNiHyzbsqu8DU6QeX+WLcPfq
	dvQM7D/y2S8hVIpdx78=; b=0CPpVijcLqBzxlrryMn8yFVcvRhKfMsFV4FMhsmC
	LtwKbPXWt4F+/KYpCGTHi8GAqRavwTcF12arKSmpGzM0vZYtolvOPmgvNEIvRLRt
	u+HJIAzLDas8gDpI1nL6qwDaU8M11kjMUoHBOlSucVmtTp4zIv7PJ+MKAtw/FPop
	df+C3viu3EYkxt2MXOvLE1SVtRNaBwPXCaMOlL9ux1VRft38kKlms3940a0hfEq2
	H1tU7kFcMhzb9Yc7LMGVSUDyVUqQ8Cu+rwlcCFWmpNRh1fblwHfzXbAL0qfMBrV9
	MX/2i6+ObtIv4d/7BCQf5oEMoO4Io3LQscu4R6uq5BCDiw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Qlrz_vqOyF0v; Tue, 18 Aug 2026 15:39:45 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:d9a7:ef1e:f503:5642] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hPYmH71Ymzlfvpy;
	Tue, 18 Aug 2026 15:39:43 +0000 (UTC)
Message-ID: <6deb385b-638d-4fc6-b0bd-bc8747cf9c2f@acm.org>
Date: Tue, 18 Aug 2026 08:39:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: ufs: ufs-pci: Intel UFS 4.0 HS-Gear5 and MCQ
 support
To: sangram kumar yerra <sangram.k.y@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 adrian.hunter@intel.com
References: <20260818112830.453402-1-sangram.k.y@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260818112830.453402-1-sangram.k.y@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/26 4:28 AM, sangram kumar yerra wrote:
> [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
