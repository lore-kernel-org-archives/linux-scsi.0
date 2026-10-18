Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37F12C11EE;
	Sun, 18 Oct 2026 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792347884; cv=pass; b=A7ngYHbzIH526gMVwYB/8syXkjRmgmg+cKKt5FMXKzj7EqEZkFHJ0w0qW/l8RUUXhS14LLZseKA/5Ckt0gkJDF1H8nV8/u5FiZzvihyXKDdcGc6Pb7T4nAlCqLXhj9pRAJWjYkOx4DKO5NXmQN05CLFqoH2bGR5ruloPir7qu9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792347884; c=relaxed/simple;
	bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NVpmrmSyjUN5VGeLYyKi36YSnLPaYbQY9S5fPVSNvHH/nB7AcOElemkwUEt7Ku+MCcF8rbFkxs6Jntb7p4oA9X65JarbQX820Lkmia/lb/2a3ioq6W1JeGcg2BgL31ID9f3wOVeJbHIqBy/Kyd2p7h4tWjFBntaljVQ1m4fLkCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Zy2X/iCz; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=qy72SpKr; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Zy2X/iCz";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="qy72SpKr"
ARC-Seal: i=1; a=rsa-sha256; t=1792347875; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Qvs85FlQ3GFR7EOuOgGr6d08uSkuEYtOh9gW5vV2BX9lxZJLTjCG/NucJIG+ViuXRF
    Ml0LcesctdAnpzncXAyfSuoW5lDb2mZdUnFpTrbn3f9AB6z2bMSR9nQlgZaSfh15hBtA
    xusk8nqaoTnPgItw08EhrYbC2zjRe3J/JZgtyofdCXf5KAhcQgZt5Me64LKPcEhl7KTu
    UKuclJ+CJnt4mYzgO9+XchCRT/Sw4a6IwH52kBncui5A4ULsa900EzXD/mUK3T9jbVsF
    a6FhMeKHj13H5rpLQnDREDJANXDpZ0n/a9hh7dpnP22qPMLS+Gp9h/JfC7XsLrwwiTaO
    4qJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792347875;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=f9PRW0uXNY0fo36oXZRMYh45n5Kn5ZTrHwtIFbfJqSu1EunD1UMkdpOEWhQjzgYds8
    bCk1NvVBJdMIRnVkdhqI9fmodhNYR7Bfq4HFWNMkofAMvV1QyM5i+ksx4jZ1HTDEWw+w
    XsOBuGiMBjBaNn57yXDWAFzVqG1cuYO7cV2yEVhdZ5VNCyezN+d92Z/rZF5RPfZ1q5Gu
    5YuiQ9WKmQp6ytao0ZF5QRODlAJkbFzOM2Vx047FpvP1bs/7ZIl0UupsvjGPksXBCfF3
    cN83uKNBSiWWol8L7M2k4R4fyDqFiGkSBhydM1u4vqI7Sg/OcSjlhwuYH+DwhF0sR2+O
    I2pA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792347875;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=Zy2X/iCzCV3TgxIIMLvX8TEJj2LXtsZ0LADH5S0eS5zH5FeHPuCrp+N6fzyAepOvuH
    iGhWnFkM5ntacpZVtDZU2D1g1Z/m6M4POEyfweDFnIbHsWZVAx87uu0UGRNSLmuzAV0v
    u9TVwhivv1WFdZqSQ8aykYH7A8e3MZZuKAA/Yy/9XBJSKNnTwhHOKrg1llOwLaF9sXYV
    z+G1uihqJwHm9fmoP55eHHrEY1d4KiQth4xeSNmfmfMnSmUcJO0aHrVNFIQbThLZPvdT
    0rUTe+yAE6ef2yzH5HGxq2lhdDGGqtOBq3bQANsuzRl60n0iIWii9w014pVsxHCRLVWf
    SFqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792347875;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=qy72SpKrZHthUMyn3Dy4Bj6M/ef0lMx6IF1MyUBGz2Ctjmca9ZxTfZB1sfuGR/RNZA
    sZDWwDNAZ4/dpkgRuzCA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzZge/Z0bJo/ZKBs7IP24cD2xnjN93xVc="
Received: from p200300c5873684d949ea70d47c97a062.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29IIOYHJo
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 18 Oct 2026 20:24:34 +0200 (CEST)
Message-ID: <95b7c186e20778557250f2f25c92dde77e355fbd.camel@iokpp.de>
Subject: Re: [PATCH v2 2/5] scsi: ufs: bsg: Clear the reply buffer before use
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
 <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 18 Oct 2026 20:24:34 +0200
In-Reply-To: <20261015001855.3450573-3-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
	 <20261015001855.3450573-3-stanleyjhu@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Reviewed-by: Bean Huo <beanhuo@micron.com>
