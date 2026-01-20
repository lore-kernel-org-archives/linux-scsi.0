Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3EE42B73F;
	Tue, 20 Jan 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931086; cv=none; b=k9eXgppivc7W4kLFEyvmlnxZQ9cKhRfy8Su764v2gP26klhBA2tHv5GpkPmYh6q1spMuIcwm8Lqo8no0SaXmc09W816rhUQcJbrZZbKZiqO0eM2wdiwK21h/p7TWIbnRMYP8laNlv+1kKKpVsuo4f1BP2RlQCrr35q4SAekHeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931086; c=relaxed/simple;
	bh=rAL6Wr3kK2sfuIOQLxh2BNLuJGx6cQHRQ++WrUiVuBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J43gttLBRkiOp0K3/DnwLtfkaWPv7WfTJjnUra/k2VaR3fwiCR2J1vysS5ysjkqc7EwLqdmlnSZPw1dEmOzDxgCzPSoB8s8/fO917w3yvY10dC64E+3RLTOz0Oo9fvKv0AJR5qRdagbzBVfbzZDmuDi392nxr03Sj0u0CunJVdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pq6r8SCH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pq6r8SCH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dwZTR5PLfz1XM0nq;
	Tue, 20 Jan 2026 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768931081; x=1771523082; bh=jSVp0+GqBqVYbXvWwMsku3Rn
	5OOybZ+l8MKCb477KGY=; b=pq6r8SCHkeRLsxJulK8m7wdsq7JxNce89K6lyAW6
	XraVAkzRlbOn0TS04ClnCXVE864VQtGCz9KLlOjkoPQsiWVojM3syjAatBGPd62Z
	jm/PlEhxJeT50V+F+tkUmdIFmNgG4/uhsRlxVjgZ5PX/oylUYSDKrTLQh3wsYKD7
	i8t7S5noxJcpsLuXToYJMAbqoAmF4BLoONN014II1clr63GE/o4MftYHrwtRPa1x
	PPltVGAwlawoBocQrjENozY10A0SLnHnQwCwdUCfmLGWfK97TtrGEKeFucztbOtq
	rBoTG+DTfBs+uj/dBvy0lSSONZddbvlLSmbydUSB2VKF2Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KYOagl7B8MUb; Tue, 20 Jan 2026 17:44:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dwZTL27pmz1XM5jn;
	Tue, 20 Jan 2026 17:44:38 +0000 (UTC)
Message-ID: <b815dd96-5518-4667-9fde-d23391102717@acm.org>
Date: Tue, 20 Jan 2026 09:44:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 3/4] scsi: ufs: core Enforce minimum pm level for sysfs
 configuration
To: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>, mani@kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260113080046.284089-1-ram.dwivedi@oss.qualcomm.com>
 <20260113080046.284089-4-ram.dwivedi@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260113080046.284089-4-ram.dwivedi@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:00 AM, Ram Kumar Dwivedi wrote:
> Some UFS platforms only support a limited subset of power levels.
> Currently, the sysfs interface allows users to set any pm level
> without validating the minimum supported value. If an unsupported
> level is selected, suspend may fail.
> 
> Introduce an pm_lvl_min field in the ufs_hba structure and use it
> to clamp the pm level requested via sysfs so that only supported
> levels are accepted. Platforms that require a minimum pm level
> can set this field during probe.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
