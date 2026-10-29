Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239392;
	b=GNneD1VlXkRHZ84BGeD3nvqSVXxAzvHbxCABzhBeQAm9UYIGt/HWACp8sSYTyGnyxSml
	 LOEDy8QseyvUwjWzZ5JdQoOQfmfir6A/uZ+KzGt+2xtXtOMr37Y12cY5aKU8jRyU5SjY7
	 bbUXuPQajKbpt917fTQB/rXMKCxspzjyjZkZrTgO+2tBwVkKtoclq2u7kxYfA4HI6KbVe
	 gRrh2NG7BhYmC7lQ1nrOWiWBHlMUu8V77Vk4RKIikwUNDH852oQwuqsZh2thmseJOdVsX
	 cMXfLhX7oDRMaMwClWgKQQjx3JnbiazmZSlvIr/l1NsKsk6lnh6vk+WHZQpD7h6fGAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Rqt9eaCxizaDxni4x7q/HGGFuh4RinZVBzC+bxiGjY8=;
	b=j4h/xYmMNUi5rq3+jo8E9xryCY/he4aC2dxMUseXp6uv32KGAW1mCLeQSLf728HEidiS
	 OTy72KX47qfFp/FwbGoi6o5mmXNFgmnB0TnYkJCt75G4anMD1xwHH6KxzhFQhG/+pA6lR
	 XR1imR3GzDbEwqkS3orTQX3BkffIexC4Gq3Moaw543C1umQTSbqhvs22ydGHj/UT2/L7o
	 9aSHLWbEmxJf7Eyc6nCOgUqfOhQhGqupyjMxYy8keDm5mYWF2ZFRoe3HhANQug3wOevgV
	 9F/bp4p/t/DkPXUzy+Qbm7Duki6OdAJ12y/M+16U3NdefkMXYkcFh+tzbLOiSxz388w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="St5Q/yk7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1E9606A324
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=St5Q/yk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826C11F01828;
	Thu, 29 Oct 2026 02:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239391;
	bh=Rqt9eaCxizaDxni4x7q/HGGFuh4RinZVBzC+bxiGjY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=St5Q/yk7R4hJ9jJEO18VTurY0datJThmzrpd9XrOqxN0EBqEWSx0sZJjjrGIr60Aj
	 PEltiYqDB8blrJ8vBWE61ua/JkNJ4+xGYaFPg7a5tdAX1DtAVja6rlkRYY8/ztXSGz
	 E8TPTJpNaJ6wkfbJzBstdn4u/ochBXxtBo9RRFijGXjlVHTqtQYTSzRm3+i/yQHlRC
	 qYFac2WAtLXhzd/HLTHhrGQxq5WEjUsCONAUb7yxa8iKyubEe1ltImRu+ffYS7qjpg
	 r9KWK9OAjbNoYJJIBrIxJsfmN7ynha3WwRY7mExBYqs7xJOWP6FQblOPGKW6gE8dQO
	 5gy4fcRvfmK6w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ipr: Fix two kernel-doc comments
Date: Wed, 28 Oct 2026 22:02:48 -0400
Message-ID: <179323465376.491807.12983446090158780497.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <64f80584ea0f557accbdc28c0c35d0d4c1db35ae.1792106985.git.bvanassche@acm.org>
References: <64f80584ea0f557accbdc28c0c35d0d4c1db35ae.1792106985.git.bvanassche@acm.org>
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

On Thu, 15 Oct 2026 16:30:04 -0700, Bart Van Assche wrote:

> Commit e2bb4cd08080 added the SCSI host as function argument to multiple
> functions but not all kernel-doc comments were updated. Fix this.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ipr: Fix two kernel-doc comments
      https://git.kernel.org/mkp/scsi/c/537bba32a375

-- 
Martin K. Petersen
