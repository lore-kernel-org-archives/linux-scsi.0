Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514768;
	b=ujvTQH7i0PDaCvFGREj+JkZU8XBXoHZCc+eCCsf89qq7q8z5juTh/lWrcN+yzNxcM3kQ
	 oNqUFD4CFCL+E6POu+SFPehS5BPb8T7uRpXzSY9CdlhZlqAcW5GWs5X8UD/sqHIVF+sgG
	 dBZ4wLNXOxOBeAim1/WEdmK+Iv5qWDSuFK0HCkHza5ZChw/IpBtePr+EGvLTD5AbQ6shR
	 4le2jkXJx9jG8SIyiiYN1XLIeFTBihNjlc7EzVwJWCAF/A0u9Z8v247jHwDtVCn+wIZfg
	 JUlgFyp+UxpYeP8Ou3wi/U5LUaPkcfYf8h6wa5Bs1klscXADRZ/CeGQHidjoWouE9BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514768;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=0vuezS3EUG8eHtvBIkQitnjbxZUN0YqI1jYbYsravMQ=;
	b=FUNkjfrw8xiw/fFHYnQI58mjvtRvGBndyJDCg+puLur9qE3okgItlhJbAB1snKz1Kj69
	 mYvqxiwMv4gSkE+O+cvC16JsNOK7Mf4HR2JDAeKdNnByWw9kdbiHacbXRIe3tudjZGEjS
	 q7yLiS/04kTswkUkZ1W0yv6Yvr9uh9A5OdFMDCFBy8ZEZXaia0LZFpBdM2EDOiRtCECPg
	 KIPm9a/6rlclVsqc/kQbZ95P9t4xIIa6neMBWKHYlT8ism675pHZGYqW+2+dyj+NkLzls
	 zoUO1j+1rvmoSkgMVNfvKFH4xiIEnCPq1gC/3Secr4vq7EkFaD8GLf8jyDeja5EYGbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yqAOPzR6;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5695F606A33C;
	Tue, 20 Oct 2026 16:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5695F606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yqAOPzR6
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j8JFq4s6wzlfvpM;
	Tue, 20 Oct 2026 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792514763; x=1795106764; bh=0vuezS3EUG8eHtvBIkQitnjb
	xZUN0YqI1jYbYsravMQ=; b=yqAOPzR6c6lztzxGfHMtiYb4PlEK6wdW7ed3kHGg
	v/4LrYbi3pPRUsds/7bxfh+yCDDQHYumR3aNOX8xitbcieX4ZSx57Cr21EJRnKTq
	uertJU1Z4Cv3m2qOyx6hKkHlSRbz4N6+89+v42OeMX1hgef68l0OnADs749W2zmM
	j2/9qG5i06xl7VyFZ6cV/2Q3GPDBnAhy1rgOQNIsmiHhWxa2kIPbzZQc/onFXfqU
	ap1XcIFkIvpB2JDvSo5opVUylAai6GcULDPLw8nvV+BdvWfv45vD0APS82rnSTjz
	QLl7nN3e+GYt2XnjiqZ4HyEpdruYjcdwH25nqbwiOfELsQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id T9nM7mThpI1I; Tue, 20 Oct 2026 16:46:03 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j8JFk3GF9zlfvpK;
	Tue, 20 Oct 2026 16:46:02 +0000 (UTC)
Message-ID: <c2de51a1-cfbd-4f96-ab02-f6d55c563ec7@acm.org>
Date: Tue, 20 Oct 2026 09:46:01 -0700
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
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
To: Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@iokpp.de>,
 Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261017084403.875420-1-stanleyjhu@google.com>
 <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
 <2060a8da-581b-46d1-a510-779f4df716cd@acm.org>
 <78888420b7c60d2d5177cbf76f5efba04fab5d7b.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <78888420b7c60d2d5177cbf76f5efba04fab5d7b.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/19/26 8:16 PM, Peter Wang wrote:
> So, should we remove the call to __ufshcd_transfer_req_compl from
> ufshcd_abort, which was added by commit=E2=80=AF
> 64180742605f (=E2=80=9Cscsi: ufs: Fix the SCSI abort handler=E2=80=9D)?
Removing the __ufshcd_transfer_req_compl() call from ufshcd_abort()
sounds good to me. Please note that there was already such a call before
my patch. I think this is the first commit that introduced a completion
call in the ufshcd_abort() handler: 8bb2dde069d8 ("scsi: ufs: Properly=20
release resources if a task is aborted successfully").

Best regards,

Bart.
