Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EED1E1DED;
	Fri, 28 Mar 2025 19:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743190452; cv=none; b=NVVG9XPOgjMWoDzbL4QqA67jNTQE+34WemM+oRb09wCbofZXFXpssYaBlEBY4/5wJdelLbQiCdfGNLWCLx/CncQd4mudpZDGFKrNrQ7tGEXXrfPfxoBKzWzrNK4jwLzZTGZCeVycZm/kSmQBQZAC25hnjIowsKyE6Yw0PKI81SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743190452; c=relaxed/simple;
	bh=1/nxEu92C/B7RHmWBrd65VDIm9xUVQn7T4ngnAme7Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nj8uCVFjCEYesOyLpCBpSrCq+02jwsQ+pEdQlCdMVBtwN/jYY1Oy9W3wqpn1W0lAh4VGCxyi1hFABuVlg+I8doCkleG2o1N8inudVeFcVM05q3xW+gMMWfR3U5LFZk37WQQkPOKRYY2beYfL83Nc8VO9bNWD1ytH6vTuXvihB+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S6Qg9b5H; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S6Qg9b5H"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZPW1D1780zlxY2Y;
	Fri, 28 Mar 2025 19:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743190446; x=1745782447; bh=1/nxEu92C/B7RHmWBrd65VDI
	m9xUVQn7T4ngnAme7Sk=; b=S6Qg9b5HVhbyddEbFBaWqDimMITIqHEndsu7g+wA
	b1lsy8PjXHV3I9TPNdsG525MapviNzjvYtEU48tPsOhMK+gL8StzV1eFnezDPFiQ
	21F22xBfRIO3FGC1McB1Ik0ZjHXWx7g6UEcfKv4nexQuQOz3HC4/6Al3HUxrz1xz
	Aso6g1dU89oEqN12CevnIYydZDCqNYPj/OZO0T9O6WthDBITqVo1I/Ce3vvvv/89
	OOj7Frhm20e9wEmt+7EJ8QhJvWeqLn1tu182SVYXrQI3MB1KXbdGtFwu3jrjBjDC
	jZzHX31LMLgmntQSVqQGxumojBIHsPCbTP8W3cB8B06hMA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jYn4x0wNozQn; Fri, 28 Mar 2025 19:34:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZPW1124jxzlscj9;
	Fri, 28 Mar 2025 19:33:55 +0000 (UTC)
Message-ID: <5f9c7657-d86b-47a4-ba4c-5445325886bb@acm.org>
Date: Fri, 28 Mar 2025 12:33:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: Removed
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <9ff613809e88496b5802a2d45984d2a8dddf92dd.1743057420.git.quic_nguyenb@quicinc.com>
 <PH7PR16MB619627C83309BDCE8BCB952FE5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB619627C83309BDCE8BCB952FE5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 1:29 AM, Avri Altman wrote:
> Maybe just change the function name to better describe what it does,
> e.g. ufshcd_wb_exceed_threshold ?

I'm also in favor of renaming ufshcd_wb_presrv_usrspc_keep_vcc_on()
instead of inlining it.

Thanks,

Bart.
