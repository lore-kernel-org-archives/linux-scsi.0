Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212852;
	b=o6k4ftZtRSgJHjdwGyiOG0f/TTuZs4JLnQPYnPT7Jfo2vjhe5CWh3awsJH5KkZEp2obZ
	 ZBLhCVBZ9QtQtxrKYXOugiNonKVUNoZoINEqKs2HMvQMhxVQnkG5nMyJuh7rOYQ3fRPjy
	 jmTKN7edjZgFNSVtjvNeDErISpIcXcMNayf5xL4hARtTFM1vs2r8yUaB7tAvsPlLDGPY0
	 Rz8aV0WxELKwNbHXXc5Jzf/+8ehy60J0yo2qhVsY7i2jel5O2iSSxczdq6hx4O/9gV+hd
	 apHFNivmJHyRLbfwSei9HoYtoNdojKxJT2i5hN904ONHerKZyI6zWyrEJfLAnr2h+vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=38YjRw3XFCX/Ql/NfUUIye1DUBOgX/1UPpqGpaC2PX8=;
	b=F+zXSEUoag8NmdzgHTum0kIV5FW2ZaeCtKbqDjT2m83/+mcmGnrbA5dVJFypwyXlE+uf
	 2tzexzb2j6RBJKfSnNhkcOoVCFcKdiu7rWC7aC5fEZ9wnav17UDO/xlndCB2E/qhnuCOI
	 a1BV2Mrr7yVNwaafIVMFp0HnUCr4knj9TIO1vA6jMU3R5gY6SkUjC3CN4rhM3Od9rvXeQ
	 lZ/ZMeDWGySNRp0Po734BP0CK8KoogYntedSWEUAKDybxc+rDI0UGSuKwEFcixgfQyycj
	 qZ4nYoyRq5nMOl+mNQncTmm8Jwzi26wQlvBFNn1LnR+oMF+8yL8SfT+Ivy7EO0I1wsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=dyhXSdYK;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D1C606A31D;
	Wed, 28 Oct 2026 18:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0D1C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=dyhXSdYK
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jFGQW2fVJz1XM4Tn;
	Wed, 28 Oct 2026 18:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793212848; x=1795804849; bh=38YjRw3XFCX/Ql/NfUUIye1D
	UBOgX/1UPpqGpaC2PX8=; b=dyhXSdYKrZzmr/KB9KCkNelx9i63KI8vZFKaBOK6
	7LjJjdSPAc2Z2Bo13//PPPFZbRq9J1LtUEGn+2WMqj0Px2cHvSDt4XLRWNYvRAfy
	1RM6crMnZWd0aUoDS4I2K1cycppbsj7ESJ4JHjEStFSfN8w3k08DAMIoY0tMWqnl
	qgSqtSEAR/GUBzVP7zyT/t6g8gCqyiVrx148mBTbyxIlyQM64cSpwZ5OSmpfEe7G
	jUqZQVt0i/FwrmuW/phDE2OOnCClGycQj06C3ulwCVNerbpNNDZ3m7Bkpwuko/ME
	cfBiyeeBYFHsVrqwUAogonm8e0kOH9OOEzZlOD/j0fmwqQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0X-Qh9JJIudq; Wed, 28 Oct 2026 18:40:48 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:2401:7afd:3947:f56f] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jFGQR5ZKYz1XM4Tl;
	Wed, 28 Oct 2026 18:40:47 +0000 (UTC)
Message-ID: <96f75e1f-9b4d-490d-9492-e60bdc31ae79@acm.org>
Date: Wed, 28 Oct 2026 11:40:47 -0700
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
Subject: Re: [PATCH] scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN
 devices
To: Alexey Charkov <alchark@flipper.net>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 5:54 AM, Alexey Charkov wrote:
>   drivers/ufs/core/ufshcd.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
>   include/ufs/ufs_quirks.h  |  9 ++++++++
>   include/ufs/ufshcd.h      |  1 +

The quirk has been implemented in the wrong layer. The right layer to
implement this type of quirk is the SCSI disk driver (sd.c).

Bart.
