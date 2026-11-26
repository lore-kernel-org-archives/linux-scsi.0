Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.80
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795732364;
	b=k8ucRmc4Kp3pOQq5MSNPgeT8bzXzdeQeBNIXJQ4O8e1uMRb5WxIJQxpHZVXL7PRHSgOQ
	 424MaLqNNTTqfkkywgvBS0bMMWtv5InQS94AU4ZAjiX48SOD2iP3Yc8ojxWTxI4tb/bDY
	 5FpEsbXzfP9VGzPyBKuscj70wadLT8ip1IaP0lbdmR0AeteZnE9BBplix71WPaM3s/F23
	 iWKz/sy9VVf9O1GwZZBKAcMUHbpPK/qXBbA16AjAOmKMV2ejLmA7PoMEb1KJFaT7zbOwU
	 2TmdZIdkqVSN2bi2zLakJ2+bQ9TzH1H3mbNgsPwVtMZVUg+MpDIoMOw3NZANLdODNiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795732364;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=072KXSu5Y8dK9HjFQhMZc2Z0+IfVi5tiKrYg3wUfVAs=;
	b=i3pGkzdhnZ1fVGbR9hnmdREY1jGUfqo+Jzu/snMZRpCh8NHNP0Ozx0HyJ/4XAAxBseqJ
	 G8THNE6jWzpT7qZgjwEl3Qw7qATg3Ma0AakhpsfdWZZDdPVT+L/kysun2Z4sQ5wcpSyU9
	 2WOFFGtBTT5NrWjz4Pta2ZW0iis6FH9etBKzWDf858Z6FX6uG+9hZ/iUemI4ISeKiThH1
	 ofaDEBSr2nsBBaz2SAuDSRKrclNvYjXazK7J9xY2EY5dB1O5wqgH/+0XSwC2jnYyJ6DD1
	 sF5ASI7Gebeyw5DT1qJx5FafOBKQpbemdodehNPNfNnBv8nvFyhiwoULYaekxnrOKuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=nJkJG4Ms;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=BoAnahmk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.80
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCE606A31E;
	Thu, 26 Nov 2026 22:32:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17CCE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=nJkJG4Ms;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=BoAnahmk
ARC-Seal: i=1; a=rsa-sha256; t=1795732360; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=TN0YZqQnr+owGCP7VTltofAlwzDAMwUhy/KP8bA/sx8NWlq12paey8DkyiOS6g9PaU
    Kh0W6JtEmwhv/uHrsJuOiknWC3Foz66rIZnKX//Y/ppfw2n/YPE8xOawDizZ+uPtVVO8
    3o9a9ogGbCMLIGJwQqRk0F+gXQUF7GZJhGH+ja9gLmhzxRk3Nn04I9bg2rtL4XHZo5It
    yYMDpxJ1J1f3ygEd7v3nZLByS3s2XfsqLHetyWoFQpxj1IyNuX/eISnhpcDNslW9+MPP
    LZymoDBwhDAC7/Ytv0DxLmXnF2uDIbA8cw0SNaz19lILuAJTyFd2munEcZzi5N/yYWZb
    fHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1795732360;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=072KXSu5Y8dK9HjFQhMZc2Z0+IfVi5tiKrYg3wUfVAs=;
    b=IBf31Ki639ytlB3hsIUstrxcx7OzrfPUm2c+N2QL3jmIC3/wO7erhvFDbX1+o2N090
    6EGLMhP7YWQBepbYFfSdzJO/UIbbsfMf/p9Lr+EeyuXD8bUBsbePbPmfUqa9KDa6+Fii
    Gy4KFPdOVTDouZE+FzQGU1VQIOhDKtPPEl3zgT4WAyeh/GHjJlzru5bZcnW4Zxp+i3uh
    GQEqcp5Wovyee27oGbkQZDzFe1dzut/U9WAua9eTdyHrtGkgyacSvrs6EZKB0A+k/yBs
    Swmj1k0kv4LZmM090CqMt9HEvbqmKCpC7Rb5Bu3SJWUTCgF4LTImtAiYRi+WhNdJWccW
    VkEg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795732360;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=072KXSu5Y8dK9HjFQhMZc2Z0+IfVi5tiKrYg3wUfVAs=;
    b=nJkJG4Msx0NVcULhcGZiIs7tFi4+LmtYyiD8p6vhLOVfE9cKUBpW6tOR+C8UtxS+aA
    4PooWMZ2r0iGqeyL9bKQCgqLuCDvRzAKTfbiHSMVrsQJJ1L8WnvcTD3En5zEA8ALrAud
    ld0zjLfKuSicve+qzoKNV89DOH9Wl3+St4vnWi2oYCl1OURPEeeUdCxUxzk+7UnrwwbA
    s8e/K9a6SRuz78t18ho2yD7MbuHQvrs9LRzJLrmLLIojYkmXQbmPV5/uyMIba1//QFMj
    XeA5EbKmZEOY9dUgvTJtWfjk11YYuyAEXckVDGAWpHPUJn0TvvZSB0+cjvumotvlybxP
    J8vg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795732360;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=072KXSu5Y8dK9HjFQhMZc2Z0+IfVi5tiKrYg3wUfVAs=;
    b=BoAnahmkczXb9dExxTJf8LPWVVtz38Wg/2gHrkj4DeeRoD5BKgZUi3ABoqhrDzbMLM
    r+3UGysW/5TzTJiiTjBw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RP16IHIszTD3hB2bKri1qswmSmZySpVjD67C0o="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AQMWdfOm
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 26 Nov 2026 23:32:39 +0100 (CET)
From: Bean Huo <beanhuo@iokpp.de>
To: Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bean Huo <beanhuo@micron.com>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Avri Altman <avri.altman@sandisk.com>,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 2/2] PM / devfreq: Add more details to the get_cur_freq() comment
Date: Thu, 26 Nov 2026 23:32:25 +0100
Message-Id: <20261126223225.2257410-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261126223225.2257410-1-beanhuo@iokpp.de>
References: <20261126223225.2257410-1-beanhuo@iokpp.de>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

The comment for ->get_cur_freq() only says that the device should
provide the frequency at which it is operating. It does not tell the
driver author which unit to use, what the return value means, or that
the frequency should be one of @freq_table. These have to be found by
reading the devfreq core.

Add these details to the comment.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes since v2:
- Add Reviewed-by from Jie Zhan and Acked-by from Chanwoo Choi.

 include/linux/devfreq.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index dc1075dc3446..809ef29b9af5 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -90,8 +90,11 @@ struct devfreq_dev_status {
  *			use this directly. Instead, governors are recommended
  *			to use devfreq_update_stats() along with
  *			devfreq.last_status.
- * @get_cur_freq:	The device should provide the current frequency
- *			at which it is operating.
+ * @get_cur_freq:	The device should provide the frequency, in Hz, at
+ *			which it is currently operating, and return 0, or a
+ *			negative errno on failure. The frequency should be one
+ *			of @freq_table, as it is used for the transition
+ *			statistics.
  * @exit:		An optional callback that is called when devfreq
  *			is removing the devfreq object due to error or
  *			from devfreq_remove_device() call. If the user
-- 
2.34.1

