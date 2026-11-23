Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795451093;
	b=TPN5uqjKISz6xEVosOq1i8TL5gIqaYtPGz2XVNaGWHEW2wUgQmSq8A1f8mAqiHctX78T
	 LB3v2vLF3URo/aZz3XFtH3quhRF4yFbdRFz1V/mai7aTPYgOb4Gnwj54eNy6tSZZB0KY+
	 DS9FDSFt3XOVYkWwTZymp0JTlxgeqlpfSavgtuGQzEhhR1lLm59PG3wTXDe1kCVtSJxRr
	 +xT5LD/ov+kkVAMThnpA9Q0d0TcgWMgnh2xIoXUuPo8iuP0sjoSGu/zOdxfG7T/aiG3e0
	 CteBI9VpOcUaV0QLgzHp07CHs+W0hv2XJl7Jtk5qKy3SU8Y8EJ6Js+/1mNTYoEDtnFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795451093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nwtxq67M85oh39yiNCH/rtnkxB+wt1qe2bRCV6SZf0Q=;
	b=03YXzqsUbiUP9voCMkY+VYxEH7ge7B1W/q9O/s4UR96pFuBx2SQFKbD8HzeKMEcrCiQj
	 bs7jQCui47gOP9AszuKUqmW+pPM7b3VuhB9vI5R5lp+wnt2pfwMmY+uEwBmxUDTEGjanJ
	 8JbTj0zFMupJc+gD/2XqzfpVQy/kQSARHGR+vuXcxAuqJxI20nA8Nn2pZl8SH+/ojPbzU
	 LBRvj0i0m+AkkwgOsRvBTtBcKhRUGq6YqOq7IhqFIHacEFbdQXQB/9nQd1lp+W0Wf004l
	 ACDeu54vbmF8+qauAo9T5QqLzjAEifTWNAEnWYhhJfZvRyI2VCNvLPX1LBIj8tVR5Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=TxY3z64J;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0584B606A31E;
	Mon, 23 Nov 2026 16:24:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0584B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=TxY3z64J
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jYB9c400dzlfcdL;
	Mon, 23 Nov 2026 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795451089; x=1798043090; bh=nwtxq67M85oh39yiNCH/rtnk
	xB+wt1qe2bRCV6SZf0Q=; b=TxY3z64JqFAn7AYulPpdYjPabaXVpLJTfj2LnxZF
	O3yqoI9XQz1WeX702BOMNUg6M7KuS3u6HMROBBLrh3bwIjFpBy6SWSlI2ye5xFMf
	BrK0387MnEzLFyw7DT3roFgVDVd0eIaE5jcAdYOBfQaH3//4q6qoaUFIn4JUWf46
	kWeFwSBLzQcC27UolTtVDK9gVeJ8nqPkQzGktsZP+h0ZUrSlZhvl/Lkm6QbpVDRV
	giiGUVfqK0B3na/hPXWbURtaYlYlBxPc3/sNws7+VzkVCVDllgVVullJK1F1if7f
	mMGGMucFtWGfO5Ct35u45N8VbegfLwl72jEGW5IGM/0NOw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RFKoMy9jod4F; Mon, 23 Nov 2026 16:24:49 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jYB9Y2rJDzlpHws;
	Mon, 23 Nov 2026 16:24:49 +0000 (UTC)
Message-ID: <480f2d2f-1d98-46a0-9eb0-379004942826@acm.org>
Date: Mon, 23 Nov 2026 08:24:47 -0800
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
Subject: Re: [PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion
To: Finn Thain <fthain@linux-m68k.org>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tony Battersby <tonyb@cybernetics.com>,
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ed3e6d1536bced61166ef408bd3327acc340216e.1773122366.git.fthain@linux-m68k.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ed3e6d1536bced61166ef408bd3327acc340216e.1773122366.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/26 10:59 PM, Finn Thain wrote:
> Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and atomic64_t").

Please remove the trailing dot from the above line.

> -	/* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
> -	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
> +	/* atio_u_isp24_fcp_cmnd_add_cdb follows immediately after atio */
> +	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(struct atio_from_isp) !=
> +		     offsetof(struct qla_tgt_sess_op, atio_u_isp24_fcp_cmnd_add_cdb));

Has it been considered to use offsetofend() in the above expression?

> +	uint8_t atio_u_isp24_fcp_cmnd_add_cdb[];

The array name is rather long. How about "add_cdb" or "extra_cdb"?

Thanks,

Bart.
