Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794530149;
	b=4Cp6wNZqwUC5JjKQR33qc1VIO3c9PCGrcIyYtdhTMFlnBx+ph3KeYMUDMURj0VG6xlyl
	 x0U9N5bQhs8V2Uk0tsGeWEud2lvlKkPaL5P1VLdLfPXiwzOn372iG1p3XRUzOMrjmuMKQ
	 P1qR02jX1z25o9A7xp72l2sQ3VTkTJXvR8CBg75s9YrYqRBqLWNBNhT8Rt0mGHDHepOHc
	 gIfyNStNrbsgi5shMSfN5RWHXbZopS6CuNBmZl/GGFIDgSC8q5SUo7i+7BPcOQ6pk10eT
	 DN/IBYYq1AH9xzuMmBiZTL1Rh0LOmlScYHkExZRTnEW9CgRBxQObdNyvqPGzsnS9r2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794530149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=AMPSZX4RQOthblKsm/D6C9UAaIomRft8CK14da6DgqI=;
	b=F/0dQYZflxDj2vGsIazIW3XTcpFxu43qZsh+HGeY9zVKrfZQUk0A/bf9KJCpRd9tBUfr
	 eNQTf1kmuCmSSAX8KQ6uz4CJovpJ/BcMziMM0rypSejiO9mfJVVxIzFeJd6ZNS/WKCfWB
	 MyBVVwOZrr99LBk9+NSRYrQELqmhK5fqklf4O/3kAwSJLfVAqg01OKqVLWbv3Ju+Xt1zL
	 Atuyk6nRzCyEatxRaYikStXtcDehVA5ZZpLj0OZbrA6nig7O5+JQNCTdJik09pHmNuFaq
	 tQ1mgZXWW0agb1i6Gz87w9F9s/UkoSEzT0s9M3KvjHgYbXmKbDjBNp9R8+jN+NJ/FVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TSJ2tztd;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C938C606C255
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 00:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C938C606C255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TSJ2tztd
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36f26e6abe9so483135eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 16:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794530148; x=1795134948; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMPSZX4RQOthblKsm/D6C9UAaIomRft8CK14da6DgqI=;
        b=TSJ2tztd2DlsLnjU+jiCGBbzcvrErEUH5R1OBawcrL2udyDPd0d/bAB0cPJ3COtmvy
         iW7YGYV+9ex9Toc5dAnY7RJKoyFAxmp82UItc4nXxYUGGOGy73uepTEIJIYj2FYhcEsg
         25u2nGmjkyPJfmMVImfsUA3PQncrnroHfl4MZdWQAfxVY/boLGrzClg8JhJG8nBL+gEB
         iEHjhDm1EHKb/tQfh3ENPJWZFKP+78UmJqe2c1rlfKxzTmlqw+qBQ4Tnm7PptXYqySsx
         ac3jGA4KRUqw35qiMKGZ3e2ryvnCi8IlISDC5XFVJEio1JqYT6Lixbasz7uPPY3Mkagq
         CoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794530148; x=1795134948;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AMPSZX4RQOthblKsm/D6C9UAaIomRft8CK14da6DgqI=;
        b=0tODUj5R79V+glYoqEKWLGDWoacG5ItW+8erSbNUVHhvr+d6jKXyUuaU9Iy+QumjLF
         LL3tjJKX7IFCAp2PcdY9nNE1WF/dJdnbjGQ/sDw0vAG2d2CyxZ42tkZnMUD61RHNk8p3
         3oHkIfyGUWilatwA1fgbHmsr00SN4HX/hlNOPUDfkZ0rHoLHcXX2E3HLzn22kCjlfu/J
         J18y5ejzcPIPt0w7kvtReYSrygfW0HJ1YXWk7YX8u81ql3D10LxgBVgAA3j3JOktxOYH
         79rKPxJ6OrEUMJmZqquPAF013a32TwwmuAzmsjlrvA5X2wJkMWPj95W65aGTowpS65uf
         hOrQ==
X-Forwarded-Encrypted: i=1; AL+hErH3MoVJXWhbTcGqZQXKBMAx5ijGU/rvx/YJz+hmFdmqpvHAzX7/GOMbqa52gyZ5BJa+R2L8WdXRWR9r@vger.kernel.org
X-Gm-Message-State: APuU4Z8I61zvj5tlkPP1UjjAlo6mMPb+bRmAdNjHPnB6JOQUqklwqCNu
	OI8H043gQiBzty7GJDMnpZyfQbb3eRtaCXwcQdaIpRAkwlVRlBkMYPJq7eKLVCncS4CPIy0b2zq
	buB2lU78sqBERRTSz4se0HlKq3WJ1H11hHt9L4Q==
X-Received: from dybhh46.prod.google.com ([2002:a05:7301:292e:b0:376:93cf:d6ce])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:fd89:b0:369:fe81:a575 with SMTP id 5a478bee46e88-37967ae86famr662615eec.35.1794530147486;
 Thu, 12 Nov 2026 16:35:47 -0800 (PST)
Date: Thu, 12 Nov 2026 16:35:35 -0800
In-Reply-To: <20261113003536.3622755-1-sarthakkukreti@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113003536.3622755-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113003536.3622755-3-sarthakkukreti@google.com>
Subject: [PATCH 2/3] usb: uas: fail command submission on fatal USB errors
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

uas_queuecommand_lck() only treats -ENODEV from uas_submit_urbs() as a
fatal submission error. When a link drops or an endpoint is disabled
while hub_wq is frozen, usb_submit_urb() can also fail with -ESHUTDOWN,
-ENOENT, or -EHOSTUNREACH, causing uas_queuecommand_lck() to return
SCSI_MLQUEUE_DEVICE_BUSY or queue retry work. In addition, if status URB
submission succeeds before command URB submission fails with no inflight
URBs, calling scsi_done() directly leaks the unsubmitted cmd_urb.

Fail commands with DID_NO_CONNECT on -ESHUTDOWN, -ENOENT, and
-EHOSTUNREACH in uas_queuecommand_lck(), and free unsubmitted URBs
before calling scsi_done().

Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 drivers/usb/storage/uas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 5aa369087295..6b573de89162 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -743,11 +743,13 @@ static enum scsi_qc_status uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 	 * a command that has finished is a success for the purpose
 	 * of queueing, no matter how fatal the error
 	 */
-	if (err == -ENODEV) {
+	if (err == -ENODEV || err == -ESHUTDOWN || err == -ENOENT ||
+	    err == -EHOSTUNREACH) {
 		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
 				DATA_OUT_URB_INFLIGHT))
 			goto out;
 
+		uas_free_unsubmitted_urbs(cmnd);
 		set_host_byte(cmnd, DID_NO_CONNECT);
 		scsi_done(cmnd);
 		goto zombie;
-- 
2.56.0.611.g1030f0b940-goog

