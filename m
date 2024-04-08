Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3EB1422AC
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712593753; cv=none; b=WMHY/ljCRLCp0W/QtcarMyNH5xzSqqzr0sN+Rcz328NkCSz2KL7TcD6LooUUL//1VxgnhiMQ/5Xn4StE5GJLbVCG1m4R+v4xFl7rskvwhJIi6vX4doxvRnKbbTQLeVqN0IqzdJWYONM3vQP/pmH00LJ793IcmvB6gjplIo8xf8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712593753; c=relaxed/simple;
	bh=6RZfu1JVw/ijCtyQec+/qysO6tF7EfJPTsZFWqIMDjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkhUmEb+MCDSzFRq0quIjYzTDSxanMrZ16XL15fF5fYh0P/wTiAZc80g0Qm/eTi26qtX753qOC+rxhG8ltJFuYdINgcjfInkEAmYLTXgylb7WOoapThiJMLzdB2woTQpT5KWU7GLIGaMERhHpFmbEbYAlmQT5oU/CmSgwfJwsIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k7r+hupB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k7r+hupB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VCvgC5MbWz6Cnk8s;
	Mon,  8 Apr 2024 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712593750; x=1715185751; bh=6RZfu1JVw/ijCtyQec+/qysO
	6tF7EfJPTsZFWqIMDjY=; b=k7r+hupB1N/9oGsYTzIfj5vkVqZpXM6l+eNAcDgU
	d6ov35HSJoLVyeyRwdMFvEkVd21bquh5ij4dgbqClEqQGvlmpjlTgQeHSDu9rhMV
	sV5h6B50NIjA7etzaZWBNPhiQWVJX3at0Htq4FhS5WpGL0vUQhwX7Tnzza8kuaL2
	jKo8fDhzt4ypN5gDVdqvehjMn4ihxJntBvGTC2yfVLZMNlVjInHHRaGraoXKndQ8
	1qxdq0m/P9dy9dQkBY/9q1f+6XMpV9wQ3PgbifrAn12vFAipwLyyn0kO802p8T+0
	k/vXh5UIXYMjrs5DCKzWlRw5y5yWZlf8tqdk8dmfIzSzEg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5xESKEYjJfYd; Mon,  8 Apr 2024 16:29:10 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VCvg91sDtz6Cnk8m;
	Mon,  8 Apr 2024 16:29:08 +0000 (UTC)
Message-ID: <76594bd0-d107-4791-9bb7-45d83f920986@acm.org>
Date: Mon, 8 Apr 2024 09:29:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] scsi: core: add function return kernel-doc for 2
 functions
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20240408025425.18778-1-rdunlap@infradead.org>
 <20240408025425.18778-7-rdunlap@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240408025425.18778-7-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/24 19:54, Randy Dunlap wrote:
> Add missing function return values to prevent kernel-doc warnings:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

