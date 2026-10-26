Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793029084;
	b=jgteMaRSnHYuIRH7daZ4RvJ8oAleFcWtoeVH/VszgpkKqrfPmgQHSJtT2FVjTZQxNtM/
	 91cLZQ1Tdm6yIcAk8XXebUbb9rO3s/tYlWVyg2th2wlrvx8K9LB2kE5LtquLXEu3RbeKn
	 r5E+hDFUbl9woQBqnGpgNkj8h1PThoH63I0/e2V4DB8rJa1tN9hmYWbkeT2Tip99AL+P/
	 bii292lA1dqDtKqVNoqm1zQdJFZoFAgBIvVRbjAWQUAgAVO3xpCetWd5+7kUtiJYPLr0R
	 nW2R8rJT7WvVkU3KSXkr0eeRf2vUX5ta+4YM7n2cZhF8nS9eGDxwMCYtKoV7uv1BqVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029084;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KTm/EsES8cuunS5UEzxkNwi2Ban1kMg+H1CeX2MqCAU=;
	b=MbLGh3Q++GnSmEb/1yNIaGqIgUrq0jJpdkrbBS4aCfMDvd9LskbPHYIRTp7saZ4dlzTz
	 6cPyGq3kZaKKuhSnSMP20N1HCZyr2wlTWFhCeffCcYLbPZNSvob58nTU2yTVXFx2i+Cql
	 YQHCeKD0eTJI0ti11RqHxK+YlohHjkqVV1f7xWKVpaMLlQg6uX+TekR2U0W0ZIziOLa3r
	 TFU0DiCHCXc8gQLtaoO9y1HC5M5S2qA4+Bs4XkYMdQaH21A45QVPHL5HK/es6dEksgSRn
	 2zZvAHyWkV8ljnN5Q+/PMnMgLvhOdp6dy9+JxWCpuRscnZw0vIaeF816dSHgqgmkCGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=TKG4ufrJ;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0FE606A32F;
	Mon, 26 Oct 2026 15:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A0FE606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=TKG4ufrJ
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jCySW6WdCz1XM30g;
	Mon, 26 Oct 2026 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793029079; x=1795621080; bh=KTm/EsES8cuunS5UEzxkNwi2
	Ban1kMg+H1CeX2MqCAU=; b=TKG4ufrJRlR4tKqzCju2c4LRAyFy8+fcGyF+X0aw
	VeWB+5SDM5kZqM1lcKHv/r2J0qGGcYDIJYylGjd7T6sVH3JiP0P1dUV4qvcddnPc
	ul0gn7vazvnKxEfcarNxvEQoWpZOVCWdBNXAmlsM9zg8d0DTk3RiFAu8ZTEJIDT6
	5GcjrovfW4Jqc0uloWJG2BZazhEb+udnbOwL60w60f66y/te5AMQMvsxI41g1pcC
	hJK1kUiGTrtsx6VBp0cRQNOtHkFxR53bpiD7ruSUwXiJK4qoT0ISUkfOGpC+WpcP
	XSDh/OrzU/JI9VkqKlnV6lH0LJ2MefydaFUOVQY0Gw2qsw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rozdcBTZuH1K; Mon, 26 Oct 2026 15:37:59 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jCySR47tXz1XM4Tl;
	Mon, 26 Oct 2026 15:37:59 +0000 (UTC)
Message-ID: <ae182bf3-2fbd-42d8-a5c1-3792807e45e1@acm.org>
Date: Mon, 26 Oct 2026 08:37:58 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: fix NULL deref in remaining
 scsi_cmd_priv() callers
To: shao.mingyin@zte.com.cn, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 linux-kernel@vger.kernel.org
References: <202610261647385343iIt_Rpe2JeqxY7SCEeUl@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <202610261647385343iIt_Rpe2JeqxY7SCEeUl@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 1:47 AM, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
> 
> Commit 4cf752f6b99a ("scsi: ufs: core: Fix NULL pointer dereference in
> scsi_cmd_priv() calls") fixed the callers that dereference the command
> pointer returned by ufshcd_tag_to_cmd() via scsi_cmd_priv() without
> checking for NULL first, but three call sites with the same pattern were
> left:
> 
> - ufshcd_compl_one_cqe(): scsi_cmd_priv(cmd) runs before the !cmd check.
> - ufshcd_mcq_sq_cleanup(): scsi_cmd_priv(cmd) and scsi_cmd_to_rq(cmd)
>    run before the !cmd check.
> - ufshcd_issue_devman_upiu_cmd(): scsi_cmd_priv(cmd) runs before the
>    WARN_ON_ONCE(!cmd) check.
> 
> Fix these three remaining sites by deferring the pointer arithmetic until
> after the NULL check.

In the Linux kernel, passing NULL to container_of() is safe if the
result of container_of() is not used. The code modified by this patch
does not use the result of container_of() before checking that the 
pointer passed to container_of() is not NULL. In other words, this patch
doesn't fix any bugs.

Bart.

