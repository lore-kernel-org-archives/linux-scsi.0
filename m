Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794538171;
	b=iiSb6/zriUbxt4Z3stk4/D52yOEkZaH9vZTgikKfgUfJ9iTM9WIXx2wVzbyYSLUekyjH
	 0UwcoxWRgifibmMGbz1NtVs6NRaqBNCjI5pILFFgOCmJlL1A4n63adTMjxAiXWuBIhCjB
	 hUKxUppqETlvUzBoJvBZFDcqlrdbzReEMMXuE22CZB3Vk3oqsG6sZknLzLdN37LIS3CPV
	 fr+DqVXtLczmb68v/jS4ATV6ln9jFo5YzhU6maRP/yy5mevZKwiYLjOHgKdJK1ClZW8+9
	 jgCmKA3YxV2t1IosKZaqKygQ7y1VKu6gjQR8vqQu7XHtjOcgXFT0/CRmHxC+TIAElcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794538171;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ChnlpzcFOrMr7HW4C/J+k+WmZgfub9wZerAn0LJPSow=;
	b=QINSJs+II98gOlbCSCXrokigyfrGOyPgJ9EZtaXe8/PjZTpP6l38sm/fOClKm4N4akGF
	 F3Pzzuh7h+9RK/QYgWxW/dWEETOjLwCrkATtDOqbV0uLBQc8AqOegM9mdfu9M6OWhTmhx
	 hWyQnh/LXLkmKyhTm0NLUB8hPOQSekKRvVex3ufy49PaiNtK4qukTWVhlEptHiB6Vsd+a
	 XFU2zQhr1W+D0GmhDQeuYCv2yFZkaS4QMT4b2lS/k92ty5okFuXQRceE9L+NaaIDQf1SJ
	 0jXlbsm8KhfGhPoyZrbhrithrAVxbOsP7W3A4rpSPadsP/wtmUv4VGffHl4pk5gdZZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VL2l4eXK;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B72B606A89F
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B72B606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VL2l4eXK
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36f479b9819so588235eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 18:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794538170; x=1795142970; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ChnlpzcFOrMr7HW4C/J+k+WmZgfub9wZerAn0LJPSow=;
        b=VL2l4eXKYlAI3RV73l8gTjZeon2l4NMczG6KQHDOOPh1X+3ORCFIFfzUYZIbMk+o26
         wVo3xGZA05LfrbiRPKzvA4P+gR6Z4mbKyNl7XE8K/Db75veRVWsYMVvOTfKHXB2hz5uQ
         OB6TLPvAdNV25LbF4Qf9NhNxG5yrNMx3myv/DucUqZzIQ+njGNLhBLfRNbEsakaSYInX
         HWEz8WoFOAp1PAPBrUz3CjcqvfvpdsL4iRfvmUDl2D42VXWJw/jowRbo1Os9Hx+QZHaK
         KGFTcnOBHuAqkTTE7Hygs6VRWwmn4lmsgSCPXQUrZdlAuwuT890dW80szaVeTr4VqAJr
         YJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794538170; x=1795142970;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ChnlpzcFOrMr7HW4C/J+k+WmZgfub9wZerAn0LJPSow=;
        b=lwo3ooWnKTvXX4letPd+N42HOEXy/aahzz03AyfKAXhsRUtqlDa5NgzMxqA5maez7e
         bnPrxmM5Af4BWpXftLuWj5oLSumFmPDzTjxXmHwolmddRhZj+HUneL1/WMuu++VxRlqu
         8zByfw4Tvt6uOc8yC9kht+DGEAlfcDT7rJ8wwUGpvaMnZwq9GHdxD961+NtGouZZdCHF
         mQdEsfVssLsIuSL5KZlqXI3UB7gaTgzuEDtb8r6zhQ/LBI+9cDH6FJ+w2qJrg9zHH5iK
         NN6BMiSiGiYq98rp3Xv+zq4p7wZmwMrvrbAg1bf5yDhAIF3ckLqk0D8woldvddjC5NcR
         cf5Q==
X-Forwarded-Encrypted: i=1; AL+hErFe8DIBhHMqujh4YwJeL4wfHcHv3/WrDJFtvRnLFwzi7bAG3lwWdnRpCfxAS2ecRuEvc3yidx3jzDzH@vger.kernel.org
X-Gm-Message-State: APuU4Z+U6vZUnnOUCqp97CTfMSfuTOrhrGv778l1WvyEeFYcbkFb7t7j
	8rvSW/5kmgF5b88Um3FZnDamWw2lZCCwVGe5jRXAvMl69Hx2ip1lp0O5YPaHZZtYdaZSSy8as2g
	+gG5McZdoqbyCGMh/tcqWaEYh5ipdoXqjmhUPZQ==
X-Received: from dycok10.prod.google.com ([2002:a05:7301:db0a:b0:351:4a2a:1ece])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:4348:b0:36c:9d4c:6465 with SMTP id 5a478bee46e88-379675fea05mr1468375eec.24.1794538169823;
 Thu, 12 Nov 2026 18:49:29 -0800 (PST)
Date: Thu, 12 Nov 2026 18:49:20 -0800
In-Reply-To: <20261113024922.27977-1-sarthakkukreti@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113024922.27977-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113024922.27977-3-sarthakkukreti@google.com>
Subject: [PATCH v2 2/3] usb: uas: fail command submission on fatal USB errors
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
SCSI_MLQUEUE_DEVICE_BUSY or queue retry work. In addition, if status or
data URB submission succeeds before a later URB submission fails,
uas_queuecommand_lck() either leaks unsubmitted URBs and orphans the
status URB, or leaves SUBMIT_CMD_URB set and COMMAND_INFLIGHT clear so
the command never completes.

Fail commands with DID_NO_CONNECT on -ESHUTDOWN, -ENOENT, and
-EHOSTUNREACH in uas_queuecommand_lck(), free unsubmitted URBs, and
unlink any already-submitted status or data URBs outside devinfo->lock.

Fixes: 26d56a9fcb20 ("usb: uas: fix urb unmapping issue when the uas device is remove during ongoing data transfer")
Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 drivers/usb/storage/uas.c | 48 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 904b4ce04fc6..951d85b2e7ac 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -756,12 +756,49 @@ static enum scsi_qc_status uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 	 * a command that has finished is a success for the purpose
 	 * of queueing, no matter how fatal the error
 	 */
-	if (err == -ENODEV) {
-		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
-				DATA_OUT_URB_INFLIGHT))
-			goto out;
-
+	if (err == -ENODEV || err == -ESHUTDOWN || err == -ENOENT ||
+	    err == -EHOSTUNREACH) {
 		set_host_byte(cmnd, DID_NO_CONNECT);
+		uas_free_unsubmitted_urbs(cmnd);
+		if (cmdinfo->sense_urb ||
+		    (cmdinfo->state & (COMMAND_INFLIGHT |
+				       DATA_IN_URB_INFLIGHT |
+				       DATA_OUT_URB_INFLIGHT))) {
+			struct urb *sense_urb = usb_get_urb(cmdinfo->sense_urb);
+			struct urb *data_in_urb = NULL;
+			struct urb *data_out_urb = NULL;
+
+			if (cmdinfo->sense_urb)
+				cmdinfo->state |= COMMAND_INFLIGHT;
+			if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
+				data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
+			if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
+				data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
+			cmdinfo->state &= ~(SUBMIT_STATUS_URB |
+					    ALLOC_DATA_IN_URB |
+					    SUBMIT_DATA_IN_URB |
+					    ALLOC_DATA_OUT_URB |
+					    SUBMIT_DATA_OUT_URB |
+					    ALLOC_CMD_URB |
+					    SUBMIT_CMD_URB);
+			devinfo->cmnd[idx] = cmnd;
+			spin_unlock_irqrestore(&devinfo->lock, flags);
+
+			if (sense_urb) {
+				usb_unlink_urb(sense_urb);
+				usb_put_urb(sense_urb);
+			}
+			if (data_in_urb) {
+				usb_unlink_urb(data_in_urb);
+				usb_put_urb(data_in_urb);
+			}
+			if (data_out_urb) {
+				usb_unlink_urb(data_out_urb);
+				usb_put_urb(data_out_urb);
+			}
+			return 0;
+		}
+
 		scsi_done(cmnd);
 		goto zombie;
 	}
@@ -774,7 +811,6 @@ static enum scsi_qc_status uas_queuecommand_lck(struct scsi_cmnd *cmnd)
 		uas_add_work(cmnd);
 	}
 
-out:
 	devinfo->cmnd[idx] = cmnd;
 zombie:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
-- 
2.56.0.611.g1030f0b940-goog

