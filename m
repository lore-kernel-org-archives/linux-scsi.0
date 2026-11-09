Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248456;
	b=vAcvgnSOWwjKo7f3oV5DCZnjvYEpjuhTYp+Kq5anbUsqvsi68tAAQm98PngPqn6ywYgD
	 kh8mJrR828fq/jhpM9KMDd/pmMdeMOv5O5ecmkMf6sQdGmu0Uc4mF7KeBlMu2Dkcc/CV2
	 RPDlzPoxJBMaebrclLF0rixSxnBLufQW58UEkakwpYQW1PcXm5oV8pr4ePa+8R86iZFDz
	 olc+KVveeJgKujstxyNcduOSH+PDANY9O70l2VDDQNT5wIgfYtIrffZ6jhv31hmcWhY69
	 gLWxYU22MnakMoQ7Ww4Ku6AXa17S+rFbq9iBvSEJ/cLLPeM0bnZ0TkE+FEw7yD7pIMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248456;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LOFdn69a8B2+1Bvo0KIts9N+tDk6mfRbXQtu2eWhFBM=;
	b=F5deWxlQyvGzJdjsYZ+URCcJ3MoeiecRfEyQbBCtEXwJ/HF1tBgXW1rYUU4qrSv1AUVS
	 RGdmsbp95+xxu005tB1OspiguDcCzvubSlMAiP9LtKxlk+OpebM+DTKi8DJOONmtVq9lz
	 5dQsu4UZsreeqrkPoOcF3mPR4NZdjlFXQUExEzyFfjlQit4SKSzUWnbc7DW/Zv7W0bStu
	 4nOuZWMgFboig6+AXTJ7lTpZLDYbbfHnV3ypajSYgaC/m0csFRdi8ZZW50Hd2XMBTk99Z
	 V1LGohO2u+Q1AbU+SmRxhyZMUwzUk2hm4OGdEehKv7KVY/DIq49qwR2k6Wt9vaRRJMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=m4zJGrfK;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924B7606A31C;
	Mon,  9 Nov 2026 18:20:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 924B7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=m4zJGrfK
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jNdPs4vzFzlfvqJ;
	Mon,  9 Nov 2026 18:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794248446; x=1796840447; bh=LOFdn69a8B2+1Bvo0KIts9N+
	tDk6mfRbXQtu2eWhFBM=; b=m4zJGrfKKZnAMw/79N5eyQy4c62oEYMW1+04FKMT
	7NAWvePVwSsl9SMupNa5yKqo7aUEOJfyFJW2WTiEjAp9aaElg+sF/DKc1AE9sllx
	gnth4W3cIoOwAHnfMQHgaEsEzEXK2OyTgBX7inOeojjPagAcO/8uD2Qbks+lLFEp
	HEdWms2wVXycOveJCOx7e0/KCHkLM8I7TpckALNnhuYKYjNF/pRuOkvgLnJpCzvp
	uYfHtnvcRAHMiNUkc2VffV7y6KSIId2J5AGfXbIlA/pTMlQRxcuIwFkdruLJA7bw
	EJo7ZfIEH4NOBRyHfle5v4qj7cPzs+S6qJW6o5XhH2O/FQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SmzeoXjNWMjX; Mon,  9 Nov 2026 18:20:46 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jNdPp24NBzlfvqH;
	Mon,  9 Nov 2026 18:20:46 +0000 (UTC)
Message-ID: <3f0a4464-842f-4ceb-8f57-d88f8898ecc4@acm.org>
Date: Mon, 9 Nov 2026 10:20:45 -0800
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
Subject: Re: [PATCH v8 3/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
To: Bean Huo <beanhuo@iokpp.de>, HOYOUNG SEO <hy50.seo@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mkp@kernel.org,
 martin.petersen@oracle.com, stanleyjhu@google.com, peter.wang@mediatek.com,
 alim.akhtar@samsung.com, kwangwon.min@samsung.com, kwmad.kim@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
References: <cover.1794196863.git.hy50.seo@samsung.com>
 <CGME20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947@epcas2p1.samsung.com>
 <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
 <26fb0dedfe5348270bf38c8f7ced1d49f1103d0a.camel@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <26fb0dedfe5348270bf38c8f7ced1d49f1103d0a.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 9:08 AM, Bean Huo wrote:
 > On Mon, 2026-11-09 at 13:09 +0900, HOYOUNG SEO wrote:
 >> diff --git a/drivers/ufs/core/ufshcd-priv.h 
b/drivers/ufs/core/ufshcd-priv.h
 >> index e55c2a02c1f5..ae3eaf5ab017 100644
 >> --- a/drivers/ufs/core/ufshcd-priv.h
 >> +++ b/drivers/ufs/core/ufshcd-priv.h
 >> @@ -413,6 +413,19 @@ static inline void ufshcd_rpm_put(struct 
ufs_hba *hba)
 >>  	pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
 >>  }
 >>
 >> +/* Whether a runtime suspend or resume of the WLUN is in progress. */
 >> +static inline bool ufshcd_rpm_transition_in_progress(struct ufs_hba 
*hba)
 >> +{
 >> +#ifdef CONFIG_PM
 >> +	enum rpm_status status =
 >> +		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
 >> +
 >> +	return status == RPM_SUSPENDING || status == RPM_RESUMING;
 >
 > should the helper also check pm_op_in_progress?
 >
 > return hba->pm_op_in_progress && (status == RPM_SUSPENDING || status ==
 > RPM_RESUMING);
 >
 > checking (status == RPM_SUSPENDING || status == RPM_RESUMING) fixes 
for system
 > PM;
 >
 > Checking pm_op_in_progress limits the early path to 
__ufshcd_wl_suspend() and
 > __ufshcd_wl_resume() during runtime PM, it was before this patch.
 >
 > Or what else I missed?

Good catch. The runtime PM core sets runtime_status to RPM_SUSPENDING
before calling the device's runtime suspend callback (and before
ufshcd_hold() is called), and keeps it set until after
blk_post_runtime_suspend() (after ufshcd_release() has been called).

Checking both hba->pm_op_in_progress and the WLUN runtime_status ensures
the early recovery path only runs while __ufshcd_wl_suspend() or
__ufshcd_wl_resume() is actively running and clocks are held.

Hoyoung, please include the pm_op_in_progress check in the helper or at
the call site in v9.

Thanks,

Bart.
