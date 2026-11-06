Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793950976;
	b=txlyXt3WmL3agFeMeTJAeW+8cTcasFOwWs4UMgRCo/VM64dWLKgaQlWl8nEaX68tM1xq
	 8NLeBoBNR92rjcoWk1vLKvMfQmel9p88F7IlFKoVi7y87cQnvzLIZcVRLpsNHZT0VtgQg
	 nOmfzKPw55jZgX/R8syeUPibzKkpKZRZ4ExkFl8zSVMS99BlZscB5y9+3GHleMgeuginc
	 JhqM36+teLZ50/BP8C6uyRNHku47d8sNDzeV0oXf9KwTVqjq2W3BorCPJbCJiCUND9eDU
	 S20e2Cnox6Max7JuqDEB66aSwEDSKZZy3Y8RVAE9zueGg7sCj3ARdQZGdhoqyNFQKLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950976;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=tkubsJ1bObzMQpXJPsRN9ahSAikhDkt5hh5bc4LcZyk=;
	b=igp3zULwJDopeLbbIsDAdgsq9T9CvfWCosyhmEAskXUKvaK8spXipAwbADeaxUYnWyZv
	 ZoVewGqk1XFFCkRPjIzxBoZ2C7m4xjo0XHvb/N1FgCNqynF8Ff2b5AuflpuHRRyWm0LrZ
	 hRxviyMvf68vk2s4gQCJyuNIH9iJq2QEyShClE/wjqDS14k7OZ/GXkNFAvRKOwt66ee7U
	 YkRhdEN0J6h/MHIguRaimJlWrX9eBirKHOZXjkSxk63uX00wRUaROz4Y1xeSQUH4OwqFe
	 +N0ah5CbzY2mjJCCadOB80SD3HYv5ZhzhmVmMxI/XznYqNKZ0rqHBiLxIUe7YnGK7WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA3606A329;
	Fri,  6 Nov 2026 07:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74EA3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLWP85gHLz8XrrX;
	Fri, 06 Nov 2026 15:42:52 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6A67glkP020846;
	Fri, 6 Nov 2026 15:42:47 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 15:42:49 +0800 (CST)
X-Zmail-TransId: 2afb6aed84f9939-0fb55
X-Mailer: Zmail v1.0
Message-ID: <20261106154249447T0sEhKHXg8J8MF0Fo1Op0@zte.com.cn>
In-Reply-To: <1023acf9-999f-4e42-8dff-e84a69c7e259@acm.org>
References: 20261105193339565ydLHLai73bbBko0TtjrtV@zte.com.cn,1023acf9-999f-4e42-8dff-e84a69c7e259@acm.org
Date: Fri, 6 Nov 2026 15:42:49 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <bvanassche@acm.org>, <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>, <loberman@redhat.com>,
        <jmeneghi@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCA1LzVdIHNjc2k6IHN0OiBmYWN0b3Igb3V0IHRoZSBlbmQtb2YtbWVkaXVtIGNvbXBsZXRpb24gdGVzdA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A67glkP020846
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Nov 2026 15:42:52 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AED84FC.003/4jLWP85gHLz8XrrX

On 11/5/26 09:21, Bart Van Assche wrote:
> The first occurrence is in st_flush_write_buffer(). That function
> submits a synchronous WRITE(6) command and has nothing to do with
> write-behind. Additionally, I count five conditions instead of six.
> Please fix the patch description.

You are right on both counts.  I will describe it as the synchronous
WRITE(6) issued by st_flush_write_buffer() and drop the condition count.

> Please declare the argument const and please choose a more descriptive
> name, e.g. st_all_written_at_eom(). The "All written at EOM early
> warning" comment from st_flush_write_buffer() could be moved above this
> function.

Will do: const struct st_cmdstatus *cmdstatp, st_all_written_at_eom(), and
the comment moved above the helper.  v2 will follow.

Thanks,
Shao
