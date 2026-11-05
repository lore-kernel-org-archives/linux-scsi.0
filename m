Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899260;
	b=LGmSjdUySKD/nH+6SFlz8m1KVUblveVhxc/tY4rU/QxuWkHI8aKO13zxjt2d//6hSCmu
	 pN5dxBGwDQEXaMGGjLRwHSRelp2RnSMb5cnJh3Y/2d8pB/ClfjzpfN46kokvB0Lg2MEc/
	 BkLs2sdg4jbxSZ+hXu5FRrch0r9dZsUfdXrFFh9XBHKNVeGt7SqgIUr5frD1D2zuYjL+1
	 4wQO3sCKu7qU7ie8IWy5zKwmtLzsdAV+8OrYpNbSnVca0L9YRpxJ9mwI79ph/lPOjOiZX
	 YNdp4dEMoCnj6L3B91go1WzPOAHY74I3sTIKl1aPp5/bbGwH3KiwtPQWWMPPht4mvFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899260;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=P8xg7LOpm0Yreuau5tzqB2tUlBOQ9+IkuT/oQxUg/yo=;
	b=pEkaTdbaehztu1239Reo52wvY8Nm34hBXb5/r0YbVKOpVQjTJhbkeoeuyS/DfmFqXxYr
	 /5Dl4eZlDLOKx7HTDS8yQDBep3WPy2oGHveU6f786gO/ZfsjXpC4nsbh4opgRSDHBxCVO
	 i/gyZbUUPkrqzPso7UYgKhNrJGsfXqDtVPFnUARnHh+uW9R4gDRLhWUM4LhEqWgsFTFUR
	 f8hVckZZFT3MY6w14EHjBw03gqnAYGMqPihkO1GxwikCk4E4BVaK/yhJIdIkP6WOQk/go
	 +VocPHKKnTO4vhNM9vgD9x5ItX3B7sxi3nBlfpGiKzidXrAgJUjqFmWCxEI3b56tl2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=eBpHHJM2;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43D606D815;
	Thu,  5 Nov 2026 17:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C43D606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=eBpHHJM2
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jL8Gg029Pz1XMYJP;
	Thu,  5 Nov 2026 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793899256; x=1796491257; bh=P8xg7LOpm0Yreuau5tzqB2tU
	lBOQ9+IkuT/oQxUg/yo=; b=eBpHHJM2y0ezgA8DW6b4bsGFaAnikhZjTVO1UhS0
	MF19ER6Hofm4E3aX6nxjXV2Yg065sfmOrr30QKIP88ufxYbO+EMw9Qe40p3g2Otf
	439wK2hfoC2ky6Fvldu2Yjr6XbUtdrSd+nya68votbRptMckMlqvpB/saL7fodv6
	RKlTFsBTY8UqjFtyR9Af1tPIaiDyKj6wAFeZYtxTGVkrRo1Ks84hrkRvjIlP5old
	3OOniIAXC/XVqBm8ReqDtg0CGMvOupAWqSb/vGxt4WdMYwRJaO2CO3WXHk6/fjhf
	2VZKSHRUwXlIj+y9Tzr+sjyYPn7a+9GM/D2N52VE+DhrVQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QrbYkzAl8vg1; Thu,  5 Nov 2026 17:20:56 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jL8Gc1059z1XM6JB;
	Thu,  5 Nov 2026 17:20:56 +0000 (UTC)
Message-ID: <36444b01-a31f-4ca0-bbd9-49c83d045965@acm.org>
Date: Thu, 5 Nov 2026 09:20:55 -0800
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
Subject: Re: [PATCH 4/5] scsi: sd: drop the dead -EOVERFLOW branches
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 beanhuo@micron.com, stanleyjhu@google.com, loberman@redhat.com,
 jmeneghi@redhat.com, linux-kernel@vger.kernel.org
References: <20261105193338195knvPnRIVc5cwFpUvGK9yw@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261105193338195knvPnRIVc5cwFpUvGK9yw@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 3:33 AM, shao.mingyin@zte.com.cn wrote:
> read_capacity_10() and read_capacity_16() no longer return -EOVERFLOW,
> so the two branches that check for it are dead.

Please mention in the patch description which commit removed the
-EOVERFLOW return statements, e.g. as follows: "Commit 72deb455b5ec
("block: remove CONFIG_LBDAF") removed the last -EOVERFLOW return
statements from read_capacity_10() and read_capacity_16()."

Thanks,

Bart.
