Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEB024A046;
	Tue, 14 Oct 2025 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478939; cv=none; b=hqbC6We8/yH3gA8bjocVhXPL9m3PK0/WlQXvsDj6hJjlJkJ3sSsOE/6ui6ZNZyllyNQIMlr7E24DANDT5AqDO3sXOwUgwccpHTItGcFBJ1RzRaOAaQqq9Fb06zu7NHSLjIAdZWzAgajTXPL1mk9Sdj8kre4E1tf7k/h/It8Fs7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478939; c=relaxed/simple;
	bh=Y7/5qpecp9/ONuRYRPjBRRnJ7siMnBweqQtH8mLnpgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+Khk72baviliKCgrwk/iJtnR0oCwLx02lvuMYTRW2PanYy5QSD4rF+r0PI53+GdZcrVZZM/rJ+Xoi9f3wTVmT9syphJ8XGxIRI0A7IXxBsNBQenOshtdkfNztk7txw4iw+oZxOMvaJePaqO9bOm0px3sy8kKquUsx2nxM4+8Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=j4SQ8+QY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="j4SQ8+QY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSh86Sw3zm0yVS;
	Tue, 14 Oct 2025 21:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478935; x=1763070936; bh=4jBEl
	zAEuh2ZZTXiYE/BPjIoFkKycji2+KVGdWYt9h8=; b=j4SQ8+QY24DZSawuUNuKr
	KbGZQ7sZj7huOPYrUdFM36G1RCe1yoxgS9neLvaJ9qaaRV/c5KCnfanS9cgz4SR0
	FGn17DXO06hrGFwXA7vTXzU+kl15Dqe68PmkwQ9fEo60pz+DTDKGIN77EDYOP6tU
	phL52nk7RxgAkQsuOvEOLllOQTqbqnalKnVxhy/+pFQxjJ0X/sKrpL0StTfoxQwC
	OScyy0rasWzymOrX0/jt9zsR6IBljMtYzx5LYLgae1h/sfMgQFmmQ4Y8rnN6GMoQ
	zv37KnxU8VKN2RUUVJSZJvRD+zCRx7U4nuG1NR4mTI4+YC4kTkw0kOa/8BCANpp1
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZNZ8lLUv4_S6; Tue, 14 Oct 2025 21:55:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSh31gkYzm0yVD;
	Tue, 14 Oct 2025 21:55:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 08/20] blk-zoned: Fix a typo in a source code comment
Date: Tue, 14 Oct 2025 14:54:16 -0700
Message-ID: <20251014215428.3686084-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014215428.3686084-1-bvanassche@acm.org>
References: <20251014215428.3686084-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Remove a superfluous parenthesis that was introduced by commit fa8555630b=
32
("blk-zoned: Improve the queue reference count strategy documentation").

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index f6bb4331eea6..13c45ab58d63 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -621,7 +621,7 @@ static inline void blk_zone_wplug_bio_io_error(struct=
 blk_zone_wplug *zwplug,
 	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 	bio_io_error(bio);
 	disk_put_zone_wplug(zwplug);
-	/* Drop the reference taken by disk_zone_wplug_add_bio(() */
+	/* Drop the reference taken by disk_zone_wplug_add_bio(). */
 	blk_queue_exit(q);
 }
=20
