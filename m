Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793939984;
	b=RxgQ4Wf7VnOfAU441ELvcQ/DRDR97dwP5DPQTxAVSbVQ2suQ9Pjz2IQFkr0w54EoPh3A
	 9T7+lssJwo78XRMZwGseSnZhnrt1Za+xq+EOSLEiuCAjH7HF4+CQ7dif8mEp2VX6bj+pe
	 NehewgM4X2jLqMusioAWYL9a0aWmDeJkbv9Hnx4AfcsjTJlOYtXqeRjU22mnR0suG3j2h
	 ccm8rmtHrCp2r/CwU2O0yUeqAaP+kVks9wDQ5nL0t8tK2XHYFawuDHJgitt/9jfV3IFeG
	 sJN8jQb/IlrQ3h/m+spokGDLUZwe9CIanjuFs6Hi2H17VQo6rZEFDMDCFLEN27wanvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793939984;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=H/Qcqzb8crxJPavpMoI7DU0ArR8TE15ku/8r614wvLc=;
	b=SMIMr61GfPMV8qfgTtH5+7g7hw9C1Mqx9ZvXThvAM4zcSdlsydYSmJjIzggLkI/uMixB
	 icDN9CgMa/maTygCcPAFndmTvPfwrzsMAfc0MhE5TcxdFK9DrnzTy9wSCTq+aPyoX3IeW
	 MrkWCDKaCQemvNzdD5HZr3BySDLF7ctCM79WMz6edkcDys3WTT+6/TzPWq/8iY7N+3kmz
	 di6I0KJTeWF7N0MOF5XsNQETJOrGh/M/Skhoa7Gi3eDzDyX0axvziI9sXCP+0hGGwBr39
	 gAcJopx3sq9Vt08UxvL4bWVJnOECgew7uLf9Ixv8qApK+q5ExmY21cJU4JII9Ttd6fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=3iWdOKl9;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D530606A31B;
	Fri,  6 Nov 2026 04:39:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D530606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=3iWdOKl9
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jLRKj2Kx2z1XLVhJ;
	Fri,  6 Nov 2026 04:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793939975; x=1796531976; bh=H/Qcqzb8crxJPavpMoI7DU0A
	rR8TE15ku/8r614wvLc=; b=3iWdOKl9eUFRlX6RvrlJ5Y3Zk6Qh/z6bbEDUGc99
	KrKxlicMthO2HRDgi2OtkP0x1m0AMnycWysBDFH0gtyDlBzYjkk1P8HdH1CyN9Oh
	buJLPNc6HsV4Fe1C4zYfaCsMBXXFLJk+fQDp029jO7IN3tKgj4hcAe+XZXOG6DKj
	K9r3jctYUbj/cLmwSCUNU/P0unBZRyBuZygsW0BpqD5/L40awZ/v7//w4P2EdMbb
	NYffn+rolbF+Eg2b1n+lWjnaNPNnoyc75bldmWQkMu2+HISP+reckJJzpMQDUA2M
	AScDbhcGnnDggv/IyNJpKlRaGBep/3N59GQy9wHWqnORqw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yTZH9LhyR7y4; Fri,  6 Nov 2026 04:39:35 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jLRKf3mxbz1XMYJZ;
	Fri,  6 Nov 2026 04:39:34 +0000 (UTC)
Message-ID: <59f8170e-ca4b-4696-94bc-045f81dbaa10@acm.org>
Date: Thu, 5 Nov 2026 20:39:33 -0800
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
Subject: Re: [PATCH v6 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
 <CGME20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd@epcas2p1.samsung.com>
 <20261105004333.1097899-3-kwmad.kim@samsung.com>
 <8939a53e-1b21-4dd9-b65c-cbe03b8b72ce@acm.org>
 <003701dd6cea$c396cd10$4ac46730$@samsung.com>
 <ec1d1fd7-b832-4ea8-b3f3-87ff3d361d80@acm.org>
 <000001dd6d92$0787dc60$16979520$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <000001dd6d92$0787dc60$16979520$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 5:56 PM, Kiwoong Kim wrote:
 >> That's not what I meant. An interrupt is generated after the status has
 >> been changed to OCS_ABORTED, isn't it? Has it been considered to 
wait for
 >> that interrupt instead of polling the OCS status?
 >
 > Okay, got it. From what I understand, it's a loop to call
 > ufshcd_mcq_poll_cqe_lock and check OCS. If I get yours wrong, please
 > let me know.

That's fine with me. Waiting for the interrupt is not possible without
introducing a new completion mechanism: scsi_timeout() sets
SCMD_STATE_COMPLETE before ufshcd_abort() is called, so the scsi_done()
call from the interrupt handler has no effect on the command that is
being aborted. Calling ufshcd_mcq_poll_cqe_lock() from the polling loop
instead processes the CQE with OCS = ABORTED as soon as it has been
posted. It does not depend on interrupt delivery, and it is serialized
against the interrupt handler via hwq->cq_lock. Please introduce a
helper function that calls ufshcd_mcq_poll_cqe_lock() and then returns
the OCS value, and pass that helper to read_poll_timeout().

Thanks,

Bart.
