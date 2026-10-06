Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDF63DEAFA;
	Tue,  6 Oct 2026 08:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275381; cv=pass; b=ChoSXKRVYwzFaRj8oz5bqkinlwkrrzTB23CZQDIoTW3JRXyiMGC2ENznHoSJCYWw4RUa4832Idy1CaHBibiFbNtsqGxGZgj7PdNkklxS8fw938myj0SfC0lW5jm47o3QCW5zwDqnID3kyUlH55NklKKwynXWahimhYHa5A+anBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275381; c=relaxed/simple;
	bh=4ok4CNjLLt7YE2aQITRKh1c1uP2M1Efp4tUE95JfGrM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HNbkiuYueKeberKRFOSoRJRBd2pAjXFKYKyzo72dJDub35ZzHIDnRahF9NcwNaEirNMxOWD14t4COqMVl6Cqs1K9Zr+RFY66vMSSzvSnqF1KmPmDByzVHSCQPlnQQRhVd3LxRJGodNbVB5rZLVu06yoQkyU2tryq70PTTK/yMDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=oY9YUV9+; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Mse+vnxw; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="oY9YUV9+";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Mse+vnxw"
ARC-Seal: i=1; a=rsa-sha256; t=1791275355; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=OKKeVjpwU/Ckbq/6dddXKjou7HHpp5K/DAjPD9rPcQ2bIsN5ol5mfOGTULPvVgiQZD
    sC46ctr1dd0f75x0PQx74QZN8fpTYvnd2xeT5pV/KZxcuQ+Uk5rshkTwAgnnkgJX0tQW
    nQFG8aOwDLibPHWz4MbaGadMQ6FzeT0vNcc8NQNZ9QKOV/Y+ztcDbqvKPmLl1ZFYUelr
    OejwQ47M9i6yXyYkIn3IPuADkEi6v2CdxPzAVJLIx74uQNFwfPWdSrjOPPuuHEqEWVXQ
    KJf81xZnjLq1kRlI8reEjHfbHMC68ssFo4yZcfXRK6H9imY+OjHMKxCpy/wwK1LriOcW
    Mrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791275355;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=DE3fGC9qOKrA9fymSxeZ/Uqcz2Iv3Xz/JK0nunuDjEU=;
    b=SwPtgXeWczpINL8/2IAwZzXEpHR++JDV0vsRe7sxvYrGrARPKnpDKAGe7TjkLDlh8t
    PjjuAJWLLnG5nbTAzDV6lBsYjc4n3wkuDLM2EQz+X0OTueXJYqlMHK/IyRMkvj9f79Eb
    QtFGd2dhfycEsLO/ZcmbXcJzqLC9YolVD9tLLBjuCIe0lSbzxn23H+VW97lKcIBDo4k4
    V235ib1QvNTjisj+F1xL+LjBxVGOIEcYENzscb8QAUC60l8/HYT9Dd/XjhW86Lg8z7y7
    AjuNS0uss6lihhYN1TQHfKAIrI6i2vWVSMY0wDP5Ue9XLSqPGvvzCJY/60dQWtLSqVU8
    cL4A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791275355;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=DE3fGC9qOKrA9fymSxeZ/Uqcz2Iv3Xz/JK0nunuDjEU=;
    b=oY9YUV9+p5yVsq5Fe+R0+mLGmiNPOdV2UiGPL06lLftVfanVbTHNYL9jlOgBl7pSUt
    QQT67+5hOCE4jh9EmNsDmlD/qheIFFe2+hDohaVgruAQozBpXE1XoxpMtn1++hTBokzA
    eHLQ/eD0ZcpUfH1uyS245bpZb2SwnU1JUAjaAtRL4HGVQ7tKtLtgHNWabu88Nv4RaFyF
    edR20DMgm/K9APqtfTqscWm/yV/bBVtgS6rYUGZIr6UIlm9DVIH38kwwEI7DkHahAt0/
    seCiAlOTAdp+68AeKQuFogPnkZXTg4DP1pcVxThjkiOXFQkTq8Ti9o88bBUYTpxHr9Ce
    ITVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791275355;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=DE3fGC9qOKrA9fymSxeZ/Uqcz2Iv3Xz/JK0nunuDjEU=;
    b=Mse+vnxwhaecVrMvNx/VAUUBw1l8mYKZvEjtv0lUQnlsPqeIRWOc37RIMt7GbcDauA
    xxZggH55QCSzPlhJKvAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/9K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c2968TFU4o
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 6 Oct 2026 10:29:15 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stanley Jhu <stanleyjhu@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH] scsi: MAINTAINERS: Add Bean Huo and Stanley Jhu as UFS reviewers
Date: Tue,  6 Oct 2026 10:29:07 +0200
Message-Id: <20261006082907.3405554-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

Bean Huo and Stanley Jhu have been contributing to and reviewing
changes in the UFS subsystem for a number of years, and would like
to help share the review load going forward.

Add both as reviewers (R:) for the UFS subsystem.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b5c27c68e5d..4ad924aeaf16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28042,6 +28042,8 @@ F:	lib/union_find.c
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 R:	Alim Akhtar <alim.akhtar@samsung.com>
 R:	Bart Van Assche <bvanassche@acm.org>
+R:	Bean Huo <beanhuo@micron.com>
+R:	Stanley Jhu <stanleyjhu@google.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/ufs/
-- 
2.34.1

