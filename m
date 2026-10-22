Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792705002;
	b=4MuQk762SejfK2zyoi4/cx9Hh8Sp1KEHQvXb0JZx253irtJTmsvcLRqTowjH21F+0ZWi
	 pdtDsCYCCeBPoZXKbOVPRmXcqfo4808Q4e0OAaG/SbGjV7A5q4y3DJXMg2+2qSKjNxxSb
	 fJCmxX8EzujLyDaO0/o8f2G2N0lsMQgruzUzx6bDQJPQA9Q575JFr0Un2WLJCEzk8Jsb1
	 gst7aFc/n2Ln6hf/Jyjns7Q/EGCe71isOiGmWOTGZZJQLXXoBsB9QCLOe9JekMAe2JC2s
	 34waAWTd6tYBvZcDFAPHKwRWVFS5rKkC7iXEsugUmx7w50lLsOzr7w7M7AFLFzCeTtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792705002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=P97ogRNwRirjbSwuVLSJWRY7wBV86JwHBN2vx2TWdSc=;
	b=g9pJ248ftkh4oJuD1gZIdX+MzVBgUPYvt50NMWMjoJcddalBfkEtaXGEIaTz4g5We8MJ
	 nkJHBdXSULjXvuQ8Rpr3mkdRasREDLZjqWDFNNSY9YlN9rX58jMXHe2WpHFcPBFpaX9th
	 GJYRtQRLgzVPqUqwMRjHuHkJUXW5YjtNDejctgOM8/3vqJWKl3ire6qt88sTpxLxhHpXj
	 XEGblUFyTOEHe6nWOu6brv/mz9A3jTnCBjz7NZfxRWKAMnK3lA4cZ6o6KstESoFpJHnro
	 K3jTyKElDdMAlqc+a+jrQ/+Y6DBGHEfOumCeaLbKz2uYtVmQahLxgh5OF0/K6ikqiew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Uthlo9TW;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C5606A319;
	Thu, 22 Oct 2026 21:36:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C5C5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Uthlo9TW
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j9fc95pRbzlfvq1;
	Thu, 22 Oct 2026 21:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792704999; x=1795297000; bh=P97ogRNwRirjbSwuVLSJWRY7
	wBV86JwHBN2vx2TWdSc=; b=Uthlo9TWBjDilrIEqBx3alrWKMPDqs4KkIq3Ko6I
	dE76eGG4Nlnc3wA5ERZJrAI02v71VH1/YGdfssvDAO8Vi+mDaHiVO5sYcWlDjUcE
	nr6h8e3f4ENkPoRBYqylQnQqpJsXeE6DEBsDN4bBMMR8Pk4zTHX/C400BpHLkUTS
	SsS1ip4mXoOrE3WF3rWh4O0HgRu50vxt95z73Zau020xSuY2L6Aqpc5tTbOFrBgL
	yPVVVDGY+RZeMGibKy1X2/llPvJfwxvXtbPd/NqnLecC9/5kIF19vnr+wj9qOzZ4
	46CD7zvacY9yQS3nOvKkQm+E+vIPkTL8XmtgSVmBNBWFVw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tkT0WH8Qat7v; Thu, 22 Oct 2026 21:36:39 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j9fc63vt0zlfvps;
	Thu, 22 Oct 2026 21:36:38 +0000 (UTC)
Message-ID: <70292f68-e61b-468e-b055-caa164e7996a@acm.org>
Date: Thu, 22 Oct 2026 14:36:37 -0700
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
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
To: Breno Rodrigues Alves <breno3011alves@gmail.com>, linux@armlinux.org.uk
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022210252.80844-1-breno3011alves@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022210252.80844-1-breno3011alves@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 2:02 PM, Breno Rodrigues Alves wrote:
> Both routines are simple pointer walks that a modern compiler handles
> just as well as hand-written assembly, so replace the .S file with an
> equivalent C implementation.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
