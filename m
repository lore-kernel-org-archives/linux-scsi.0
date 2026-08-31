Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F7B314A79;
	Mon, 31 Aug 2026 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181320; cv=pass; b=BIWuR+sXVtZbSmXybV6S4x5z1OschJcS6a399RWTSe0l3GG+yQ9sXsFx79QCcpF+5imDi081ERbj6xKgdmQBSh0+UaYkJGT+AWCzE6gVh4tagOFQPBnQ/uE+AjCsL++SMrNbkLVUw0UskkI0M21uGNL3XJKpkB9n6LZSKLDMbdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181320; c=relaxed/simple;
	bh=WWMfqDeoUapcnUvFpaGWwoF0HEapcYfpFETOMYA9Dlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSxntbjQqGGU9gk6Y0BfUIWv6TmeRI8N+n05ScZjtXEnJQz4xSQYcIgZQ7HLTtloAKpTMIoptKoVne8XJEYV+E1B6UyaARfh9qm8528hvUNxxde2Le4yuf8t8aWFu7/qHN2c5EpWd+MDJLB2QQ7xJXxFEyleXqlbTuCv2CjB/pA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=KYwIwNfz; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=LjeAGzce; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="KYwIwNfz";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="LjeAGzce"
ARC-Seal: i=1; a=rsa-sha256; t=1788181300; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cpmcnQr1q3Axe/66FO8sXyRm3HvwzeyJwvAaY0QeDAuhhCDAFo/BgIv8DHu2uCIrAs
    fqDV9SeQ9LDwK58ny3/z2eH9oPu/WQ4jBAkHeRgadO4dCiA/Je4c4o3Wsg/UDjvRZwEb
    Gl7e6XHSOeqtlR5nPFLT5DrUYzZqRZdzDjlKYaIu9MkHyPY/EG6NUPwDBPO2YKWOKBhG
    97eYCv+6Snq3njabFw9C9gRBjkf4NHHsk54JJQEoYqX8bkRe8nNm3aGU21G28oVunkQ4
    6qpE3rZ7AKfiVAFe2lBMGmNiSY291wfzE+r+uA12QAdTLxNwbD+vivMAOfIT4voqYWS7
    F0jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181300;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=hMmdCpitcW0C+fnS3gjjIWuyuf7ujXR/AKQ3vpCycXI=;
    b=ZKtpTJyiPuGqYok7LY+8E8EM/4i00c9ckyB+mBuzrSe6nA97vnBcvsyJ+0f/+VhXfs
    fK6Ejsi4vYIq2Huq4UG7I6tMhz9anpwjYOI7TqvBaElNHRJdQF/s+vMlO5PTu4KaEduY
    tzOdWrWLp2e0X3kzfk29fZ8y6I0SXwl6jCTcfZDb4edV1lbF+WrQer2sdGWP481J7r8l
    WJPU3PdWCcSRcAzfwAK54nziate0EjXivDdbl3b1ud1dJTkWoOa+NlFhCu2C/iE9b9W0
    9t/MYj3eeec3Jy/i48FGP1WSS50dVSr7PywqlkHExpajj9BTJaE7H75a7An3p1CRgHk6
    3Cmg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788181300;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=hMmdCpitcW0C+fnS3gjjIWuyuf7ujXR/AKQ3vpCycXI=;
    b=KYwIwNfzsGqAtS4GTasQ64ozuVoYH2X5M9BC3j8oyRxXN0qRbMYSRNBS3tr5VyzS16
    REJjv1GJ9Moh4CeWjloBYVQcfTA/rJFGYRvwVIIcCeej5MfZbgV2eWC8FUsHCV7zTXy2
    0xuzkw0CjBocmPnSgY9VEnyuaTks7NsIUhfpQU6dfI5hDg/KkvGP4fy8PF1hzFIUKVMp
    u8pzVRWEWJCV8yEiNn04zjq8FDFf8L5GhaUWpkoo9TpOwiETrJgIEa3/I6VbeZbaz4/f
    jw/V2Pf0TNylFz8QOWYkNuxJMA2Bh+WX2Dakvpf03AbOk2vknzH3bu8ZFE9N+6tzmLt0
    59Iw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788181300;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=hMmdCpitcW0C+fnS3gjjIWuyuf7ujXR/AKQ3vpCycXI=;
    b=LjeAGzceTeEhnTb/vKaR6yynRpDRGNFKA6MQbqvwaumGTS1y6egIJkDZMlPbBkUkqU
    Om+inzgnqKxKRYpYuFAg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/xK"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127VD1dkHl
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 31 Aug 2026 15:01:39 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 2/3] PM / devfreq: Add more details to the get_cur_freq() comment
Date: Mon, 31 Aug 2026 15:01:28 +0200
Message-Id: <20260831130129.3979454-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260831130129.3979454-1-beanhuo@iokpp.de>
References: <20260831130129.3979454-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
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
---
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

