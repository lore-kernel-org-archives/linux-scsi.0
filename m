Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239401;
	b=RNLCpTIEXC4/G9RuM5JhM4EBabwhpZmIt69f6WxcNPSzT1Zm0enoOHThdpYl6weN7ZPJ
	 yRpRWXmMQHv4KazD77zDBcy3yoFovtjKtVf4sU7ApMJMbvK1QmMpAkdAILNnFLWGSEIrg
	 +UfX3AWD6D4Faq91QhD/eNsma8OwjVcmUvS6W8Mb0BSkaTqSc+N07w9aXVp8VR6fZ0A8I
	 Z3uf0qJlIH95PMkCg+1VJeqPH9D5+HM+/qDgQBBrFxvrOZoZRRPeU/Ex3NQkg3WHMIWYw
	 1HTf2cHuSmwx79JAtxMbc+VLterUMqBSD47nzNBEf5R4o8daoBTvTE0ZbZ3c8eK9P7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SQ7JaLZSLiUQ5g4if+54UjHwcnxFW5pCEwCMVYRQZWM=;
	b=NYYAxFq3U0O+PemsG0yVlStuoNhs8E4ypGUhjQaSHS/GYHRvVyrzFVWpj9EPwDcxEvcv
	 bEYtZyZR3ukpN97QryYsjf4JG4VnPx2te5achF/zRfdaChHq2I0yqSWgnG75XdpZMQuT7
	 vzPLW7yZ4ZPd7PU6NP1TCMeCam5HAvNx/9TYL9YbyjMOHxujRSCZYwoadbfend3x2fkts
	 f7gs7S2hB8Zho3wwsLKqO+KidQGTRMGXnYdSHrECQ8saC+BUZRh36yq92xc6ThbP0HFy+
	 OXDVvrAzFnyKjY2bghweGAgCr4kDDJljGF4NmC3/Kuk28oCLVOF9GkwPwx2nc6Lgaeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3EhdETe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0898F60A2603;
	Thu, 29 Oct 2026 02:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3EhdETe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBC81F031E3;
	Thu, 29 Oct 2026 02:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239400;
	bh=SQ7JaLZSLiUQ5g4if+54UjHwcnxFW5pCEwCMVYRQZWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3EhdETegcg7W2O7IpbGARelK3bGVCfs/mSDyreSsF7ghYqXJV6ZuUL3Tn7lQ7vyp
	 EQ97rolNE85v/1Jt+GqGJzlSQtHC04nGnqakGx+Xwn4UDuwPL6AwhrCsUV2L3geFSf
	 SYJK5voH0BA3yzh9SQo7jCSxitE679R2ZM4lBN3NY3WYxTT+Up5jDCVIPSpE/7WE+G
	 sNsh4eBEYxAwbQDD12X4ApG+AMQb2Dxuu+tbms4JpvIEkHmRnzWhZfmj3GyvHeXWg7
	 3E3xp0YOZ2n5+QSSAhQLAPqmOqRT/VFThG1xek8DN0ZBRsbctz3Iogg6+Eqrag7A7n
	 S4L9Gr5LJ5R9A==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: core: update cdrom.h coments
Date: Wed, 28 Oct 2026 22:02:55 -0400
Message-ID: <179323465389.491807.14704114576218745849.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020170603.3692218-1-rdunlap@infradead.org>
References: <20261020170603.3692218-1-rdunlap@infradead.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 20 Oct 2026 10:06:03 -0700, Randy Dunlap wrote:

> Update the location and ending value of the cdrom ioctls.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: core: update cdrom.h coments
      https://git.kernel.org/mkp/scsi/c/5b0d568e183e

-- 
Martin K. Petersen
