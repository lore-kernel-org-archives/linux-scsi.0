Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4867F49D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712593700; cv=none; b=re6dUSWpjNA3qsKk9euw6A/qGnzvlEqNJ1r4DCFVOYfj2Eh4bvLdJLkHz2TI5Putda2p3ecebdOVIWr3VzWmwsl318WxQBjdPC65Zav6ZgHpnFjA2LhP2/TOa3oBIMM9i+XV6pe0Me0eshnv1hJgcl3TIoDPshxuJK7hptEPIR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712593700; c=relaxed/simple;
	bh=aRLibesfe8ur80jsRW3Adss5NBrrd8M0qS7GtKa/U6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mhdbDBZnTjjOStxD/C9J7hY9CgFYXAes0wqDCWCoze964RqKRvqrZvTWIi0RC/AZ69+8QD6YbL6U6s5FDBavxvbvuzJt77+9UrX993bnrnMh475x/d9njBdx+uQJdO9ZbgUPTtTEoQynVrteD1oTV6ltRRYuTuE4zxf3yWqUktA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4OIVN58R; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4OIVN58R"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VCvf414BPz6Cnk8s;
	Mon,  8 Apr 2024 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712593690; x=1715185691; bh=aRLibesfe8ur80jsRW3Adss5
	NBrrd8M0qS7GtKa/U6o=; b=4OIVN58R87d64udKEu16DcgKT7ypBtkrcyZi5jwW
	EAu9BcwCoT1DNOOGYityRGqoWjivhcBsxkUH0MK/0ZNIU/pHd73+y06teaO57M79
	7pXne0rfF+pPp5uoY8S5khakn97/VnFKn01oVfgVe9ljYJD/b0qYZqMciuQBtH3M
	xC9JIEPb9RsSpvfGHBvPTRc4ltMlzYOf/3bOF4Nuv7BwwzAVXaHVE1C9Rae2uUbE
	1Iq9cjIDAL+5YcUgLXdM6fkPPOhsG3FPLGIitk6aNrOQR4tzFliNK/k53cwROnNb
	kUaJCT23aF423hhsZKBIQVofD4j1L4kIBRyEPskQE8lTzg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6qxWBi-YSLUw; Mon,  8 Apr 2024 16:28:10 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VCvf14Xl9z6Cnk8m;
	Mon,  8 Apr 2024 16:28:09 +0000 (UTC)
Message-ID: <d43191b9-cacd-4bf0-b2d0-83b69be9a999@acm.org>
Date: Mon, 8 Apr 2024 09:28:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] scsi: core: add kernel-doc for
 scsi_msg_to_host_byte()
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20240408025425.18778-1-rdunlap@infradead.org>
 <20240408025425.18778-4-rdunlap@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240408025425.18778-4-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/24 19:54, Randy Dunlap wrote:
> Add entries for missing documentation to prevent kernel-doc warnings:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

