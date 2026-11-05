Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899294;
	b=fqA6NGxvoUqUKyXanGQns7vQSjepyQskVjQr8cIy8JyEAk5j97SoWGBE5zSPZWa1l97k
	 qHVjd52Ee49cxTdGEzoOfzNEHKP4pPOwaNT8f4XMcSoSKPGdRbLBFBNWzkPJzu6MUBwVM
	 5zhxMEhOSJ6r6j3nVU6oWxAii0Qme4STeYj+LcjIQgEV80G7MYsftcFl5TqPbvliJ4T1T
	 d/bZH1W1yranf3rnaiWAuF2QCspAy5yaswobddJrKfuBSTcQYSm4of7FmrqD5gSa4XshQ
	 1FXoXeYZBi/aM33MEiU5WAZeyyjBLEBFzpGnLn2Z/u5yYyvG19IOFirE3eIr5iqqrag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899294;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zKlFUggbgpz57BcogDH6FdEtlO/O/2Fkqy9tqTUC6qE=;
	b=P/wRW5XW9jD7WzV+hoVoVwUsg//B1ApwjsRZqgPmYd2+CnFwcz4i4wT8j6X00U90IQEY
	 +ZIYgF3iK89EjQ9IqDzYtp3huxCOYGu9MFQwINcru5r4w5hwCEHRSeYKntkidV0yU5TiM
	 LsSFHO4n5dsd0uBKBpHBT5NRSCFQestc//W0OgKxS15V+/7kyL7tmPqC/tGQbPdVftNMy
	 ggAu+BLhI+hoch4BZsVF1smBgejbApUpfk4cPxT1zwR458mQcWN7K5w8+1WhYGkU7PNdD
	 9vnybsKjmQd7m6pW93LJG8jc6CXwqryTlaTGcyj/9eYwe61ULGDnoOeaJt1xJWGRfwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ER3S79DE;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C063606D80C;
	Thu,  5 Nov 2026 17:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C063606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ER3S79DE
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jL8HK5cylzlgyGk;
	Thu,  5 Nov 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793899291; x=1796491292; bh=zKlFUggbgpz57BcogDH6FdEt
	lO/O/2Fkqy9tqTUC6qE=; b=ER3S79DExG72Ta7oeflVOJ3QDwzi7LsntNyfqJIh
	QV0DJDEaKpONiaCkYVJz3SpVmARQ/7QFkN7kfxM+Z/uNkkZSxq1jeXjc1fqPNku5
	uJ8OXj17CYgOoXYtB9ge0K2r+APBwOKDxGlMRCNt6FHaw/huhflH4il6FF29TncS
	6ld/zhAZ7Eq0jwvmjxYBSaSkTJb3Ek7isc5enQdzdjy/agyGwC0R/oYzH04ISLRe
	bozp1mjECax0k1Xr+35/3+xfzcaJIOxXZV9vSJRP+csBpQS6FT9loKI48XTWkYKY
	9OsnpbHhSLebs3hnHmdDp36lWxxI3LAUqZ3fCi+DtCvp5A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aBJHk-bDqkCM; Thu,  5 Nov 2026 17:21:31 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jL8HG51Ylzlfl7w;
	Thu,  5 Nov 2026 17:21:30 +0000 (UTC)
Message-ID: <1023acf9-999f-4e42-8dff-e84a69c7e259@acm.org>
Date: Thu, 5 Nov 2026 09:21:30 -0800
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
Subject: Re: [PATCH 5/5] scsi: st: factor out the end-of-medium completion
 test
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 beanhuo@micron.com, stanleyjhu@google.com, loberman@redhat.com,
 jmeneghi@redhat.com, linux-kernel@vger.kernel.org
References: <20261105193339565ydLHLai73bbBko0TtjrtV@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261105193339565ydLHLai73bbBko0TtjrtV@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 3:33 AM, shao.mingyin@zte.com.cn wrote:
 > The same six-condition EOM test appears twice, once when deciding that
 > a write-behind finished early and once for the WRITE FILEMARKS path.

The first occurrence is in st_flush_write_buffer(). That function
submits a synchronous WRITE(6) command and has nothing to do with
write-behind. Additionally, I count five conditions instead of six.
Please fix the patch description.

 > +static bool st_eom_ok(struct st_cmdstatus *cmdstatp)

Please declare the argument const and please choose a more descriptive
name, e.g. st_all_written_at_eom(). The "All written at EOM early
warning" comment from st_flush_write_buffer() could be moved above this
function.

Thanks,

Bart.
