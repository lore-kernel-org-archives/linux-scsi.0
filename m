Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792704318;
	b=k7T2KoVbG+ID8jgKCWD1SVpS0K3LT7WiPCkmQou1AY2w4Gwh1J0ZA7Wzcek2HXN+mUZS
	 Ya5/ZeepzD7s19hg1TFdR5Lsh1Y37gHrBA2ksCnqOQnMKsXLcUQHckvJKr3cHtn1atXHN
	 P6VXiSu2HoF/S1r7RxWd1P7YY8BG+7n3CGW7dBkpE5ZzoBdGdJ3My15xqJftpdinQJg6T
	 bz7TA1ak29q2FolZZXd+CL/LhGyK6MBnBXHE9UjzEmFxW1PzTQRaNyQFFTiO7iv881fpK
	 shzfk+VTmEyl1mKAgBq3pA7Z0szzUMwY1jn5dtlwqjYvTMtwDW7L2PBess00HJKLZRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792704318;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=dyFVTf7uBZK7g9ZzIIt4TChM0o6lRgOy7KHLmlNtGx4=;
	b=UiWv0Hr4AxqQh09u01501F7Oeu9sZjMrhXV2uJw5lEBIzG2skuJ3aI0h7g+MAoB/+ygU
	 +TNoA2umehwjM2KyhTrantSJEIk+7MEaffd9j1eH3nmkuNComCiTfiFSUN+EpH30UPHkF
	 qrZSC1KFzfwMKCv5V+hQewyLIzvV4CLi4Gh//BLgcyYuPdxrqZIncDTlyODUgkKoF7FQO
	 Q02AAnY8e8cs+KfgnP8TldNJFjAAIdvAUxpBWh97oYLUurYkwni72cXHHxXK/ieZ0todt
	 ut+yAOWLD7KiO8zll8jJ4UgU+F3gwIfcv1HuolaXSI7VzCF6ArRvRTFXjOh8qVZ7pVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=YEUdMUT+;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=s8avq4lP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.170
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FFE606A319;
	Thu, 22 Oct 2026 21:25:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8FFE606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=YEUdMUT+;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=s8avq4lP
ARC-Seal: i=1; a=rsa-sha256; t=1792704281; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hA2OsiuRGoYNIJ4V+/pHytRRkpfkvlhfe+bcRsLwBo3efsCSHknIXjhpLCMkcZv7HI
    7pR60LJvHk2ffnUudWKhc2hjleui08y5JlbwoepoVI1UGpCLDGCiZR0KWpLTSjHSkElZ
    VwY7My/1hAnaW2/x6klvepVSDOsCIke/OoP6J+jqjBE3/a0aV7QLzF6CTosa3sX0rVJx
    C576PZLi1NOA1o2fM7A8rCwxoBjFfLoP7ej+0DQNAtCA4hSVfw6J9bSS59JMOxdF17eB
    Jk5X1fuKxTpEBHL359YDdWdESIGSff17NDUxCE1WricnqN3SzzbahQtDc40/3CwhtG8r
    i2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792704281;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dyFVTf7uBZK7g9ZzIIt4TChM0o6lRgOy7KHLmlNtGx4=;
    b=ElZbfH+HF8bdt0E5+wsRWHjsYJ631RIgEldbdPfqF2CMca8kDnYL3jc7+GT+qVkmsA
    ZxmmfkOst5xizNzqaJkJCQojdIGVBvfYUJzQJpUq40WFmp8GAnB5ceA/Biy3iAwLsGEz
    iqEDWtNwaurG6qscgnuu96zPnfib0Ihu0rQsxxOreYp7KO30f4Nzq1XM4dpAxeokgBub
    Gf8tW2OTpMzJ2qrfKhkqahwgB1xC8diw64964A22EW308IdXb+p9YFPSB7tYg5WeENMa
    rISL4V2VQECutFn7FmOIIi482bpK/bNCkRw+txVst9epHDhb52xLIjEAg42BpoVzdUUt
    ePyg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792704281;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dyFVTf7uBZK7g9ZzIIt4TChM0o6lRgOy7KHLmlNtGx4=;
    b=YEUdMUT+sGri6tf6yWxLPETmv/+2R16xqnqYdZI/7QMA8NMcN0EiNfNFgrEmeVwWVU
    RZxdIVauwLlQfTyi95db95dxn1Gp+7gu9hVmFB9f4JLSxiL9iZkd7nOPIqiMLwhkIPJj
    XvF/kwb+7pHescK+o+KhpXo7QipzIZsOpfBGHlS/qHGAoftXwOADefDA2yXqqZN/ke5o
    7RdCHcNijgAhJQWdbB0QfKXKNv/uYcZaFGiqyNVOLOy3eo51nh2quWY3gfXw12hvB04s
    PbANlG+d+x7V7cv7z5ZoJsVuZ0zSGwzprNfe2npwn26yKblB+L5wl4Hg4l1YjtBfPyiW
    5bvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792704281;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dyFVTf7uBZK7g9ZzIIt4TChM0o6lRgOy7KHLmlNtGx4=;
    b=s8avq4lPy3H2qB/TDVMMoSIjr0z85JWdQotfHa+NfQhGQlQtn76i6ci2SYiyaRAdHj
    eUydEDf1TtIzujKC7RAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzMgm/NRnJ8fYgJntd1oEF1C773gkTGOc="
Received: from p200300c587368407ffe3ce4a1bcc928b.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29MLOfc7s
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 22 Oct 2026 23:24:41 +0200 (CEST)
Message-ID: <057e5a9fd643773a13073d1b660cede5b2c90a40.camel@iokpp.de>
Subject: Re: [PATCH v5 6/6] scsi: ufs: core: Do not release a reserved
 request in ufshcd_abort()
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,  linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bean Huo <beanhuo@micron.com>,  Peter Wang <peter.wang@mediatek.com>, Can
 Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Date: Thu, 22 Oct 2026 23:24:40 +0200
In-Reply-To: <20261022034443.3034432-7-stanleyjhu@google.com>
References: <20261022034443.3034432-1-stanleyjhu@google.com>
	 <20261022034443.3034432-7-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-10-22 at 11:44 +0800, Stanley Jhu wrote:
> In SDB mode, aborting a timed-out device management request drops a
> clock hold that the request never took:
>=20
> 1. ufshcd_dev_man_lock() takes one ufshcd_hold() for the whole device
> =C2=A0=C2=A0 management command. ufshcd_queue_reserved_command() submits =
the
> =C2=A0=C2=A0 request without taking a hold of its own.
> 2. The request times out and ufshcd_abort() clears its slot with
> =C2=A0=C2=A0 ufshcd_clear_cmd().
> 3. ufshcd_abort() claims BIT(tag) in hba->outstanding_reqs and calls
> =C2=A0=C2=A0 ufshcd_release_scsi_cmd(), which calls ufshcd_release() for =
a hold
> =C2=A0=C2=A0 the request never took.
> 4. When ufshcd_dev_man_unlock() drops the hold from step 1,
> =C2=A0=C2=A0 hba->clk_gating.active_reqs goes below zero.
>=20
> Release the command only if it is a SCSI command.
>=20
> Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()"=
)
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/2060a8da-581b-46d1-a510-779f4df716cd@acm.=
org
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
