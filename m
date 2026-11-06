Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940833;
	b=xWwmTUvwW1Zr81zl4fr/d6jgke9YBiROKXHfLcig2Zjr0En2vR6evJmvD+/pBKV9CtZ+
	 ERrv9mOSentzpxczOZn9njDHJF/09sq7Nv3G3z4nTkS5UsBGJMdGfg604Cd6mjXMKt7LP
	 0pghqH/dg665R0mReFwi7Tqw7zxoX006FjyMkkbKfCmxmgXqhorFZt3cCYXHGX6zlABkl
	 +0xKfZKUc/wIhR72Oga6Q73w/6wr4zpAfbss8dS6VPB/KLw5TC0at95QbvnZSnGsJySQQ
	 P4ouukajdF2woN938UBKDX3RRySUUU/6kUPpx9y2/Tc+W2sC1oyMHsaxkm5N6J5CiWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940833;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xqR9zId0kSVz3c7RgBq5vlt6MdA2DlFvx6nKAnIWKQI=;
	b=4NHUJC/R+FvrjGSshmPck+fU5qib7H7YBRM8aeQOeze3v+ZKbCF9PudrRCn7TYHyoO4Y
	 jZp4kYWU9WajsN/a0Yh8h22mqyzHXMwHV+QfyfgzmLWLYTHnSOiSJ/yrLSJCuKmB/h5gG
	 aCLoi3RxYNPp7Z2aTPbCGyYT2z/eHwTC5aOkj2Ig36b7iH09itaJtOZuvt6CNG+8BsJuz
	 s1flmGvMbdrKvpDm4Wo4y4w2mCcBuhLEBP+0rYlwzZzxy4MFx1UncAz05DyeMv2bAvbbc
	 BMo4RXN4NHHhwn+tzlScYit+79M760gvhQ2dJPOIgcOo4rzPrykdDcQKoBeER2FfNlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=UyuJ7eVd;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB3606A31B;
	Fri,  6 Nov 2026 04:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EEB3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=UyuJ7eVd
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jLRf84q2dz1XLVhJ;
	Fri,  6 Nov 2026 04:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793940830; x=1796532831; bh=xqR9zId0kSVz3c7RgBq5vlt6
	MdA2DlFvx6nKAnIWKQI=; b=UyuJ7eVdsg0EBf6rrqT0v/UcpUILX7vx+VcNWNh9
	EdqKcGT0Niol5byqbj/SCGB2ajZGmHXiD9LA470pFJi53j8E/6hJzOabc0DN83zx
	KdL6QBM55KxvNQNxYw9um70hZokkz8YhtwjTyspF87NslB5Jx1RMn77Ok7Gji8wA
	/gWI8oQNSsu7E9GS/5C4vc5gqunktMdjxbhhAP5FqfU1aT157fTSda9gdVlhSX32
	ykwU6f0Uqvgsa0ZlFQdYf8BHhRYJV4P+tw6Mx691KI5ODqKYpzFfoh5hT7ar/2wx
	xal21mhj5duFoavH1sogU6a/3kEXG1GDAGR9Oz35dL7K6Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MwHoDpB4QGbL; Fri,  6 Nov 2026 04:53:50 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jLRf60jylz1XMYJZ;
	Fri,  6 Nov 2026 04:53:50 +0000 (UTC)
Message-ID: <de7b9459-1e07-4707-9682-2ec40d536035@acm.org>
Date: Thu, 5 Nov 2026 20:53:49 -0800
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
Subject: Re: [PATCH v7 1/2] scsi: ufs: core: skip ABORT TASK for device
 management commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com,
 Bean Huo <beanhuo@micron.com>
References: <cover.1793938245.git.kwmad.kim@samsung.com>
 <CGME20261106041301epcas2p39724ab936d6c1cb3b5b899f674623975@epcas2p3.samsung.com>
 <ab14d2f1414fa1a0a396f160abf8c27c404b4ec4.1793938245.git.kwmad.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ab14d2f1414fa1a0a396f160abf8c27c404b4ec4.1793938245.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 8:12 PM, Kiwoong Kim wrote:
 > Reported-by: Bart Van Assche <bvanassche@acm.org>
 > Closes: 
https://lore.kernel.org/r/8446dc27-9518-4b0c-b9e9-116458210616@acm.org

That Closes: link points at my review of v6 instead of the original
report. Please fix this if you post a v8. Otherwise:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
