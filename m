Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794422567;
	b=LBIMCdpLQ3/pjE1a5nYhRT2+8UohwAUsHdmcBmMW4Ck08wGpPx5GKTaM3fTKBepgk/sZ
	 Pl7vUu0TrxIe+eRL4LD00adj+Zfn1xhw6pAHVftlCdDhtHtJFTxzCBVJx1T1EvtEp6/5Z
	 7gjWBKwf7BZgmzZ7TcHdpYhgAkgGuf4s89pCcLb8DsbeoH8XXIuQ0RiNecs33r9JDpDtl
	 K1BR5tnb1N/OvvBwq+AdqgfmHXoQrJEN6QoS8LYsFEyh1SpVt+pN91PluwTHJO7DxxX0f
	 C59cWX/EYjjeUevwzTSCR45j6DDD8JqNmgnt1WASY2mBliSBSj7SZIy9am7taAOkbfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422567;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UZdwgTcrfuIpSYM1gCDi0i+eUgKIG7RMooqWvyPgmb0=;
	b=gU2snQh/yttWThLiiGbzfdJauPAztVxYvidJFw01QMXDJOihluc/+SRe1PmQcJnGKGbF
	 DfhOM8v1AWWujIp16eRUS98N7zMUZ5PJ30eGPWi3C2cRYrwOTX6vPHX4NZGoQ9oHvGtcY
	 VzYy/wRO0UbHW9suThUouCW45J63DojljhSPkRCbvuBQnUEAyoqPuH7Tjt8hpIe/3b0b0
	 Jd2ZhE0xSIiLHsanRowxqsUk5E+lrgc71raMrrz5faHPPqR6E+uqa7ZRj9MvDOFj1/Jqt
	 BLluYvc3D3ql/5jQTXdFFi7OtWm3k4regEE00kFA2ooVD+sX1IhLZWt5xprfhP9catg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=jmYHQ7rQ;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=OLEqGKP8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB77C606A31C;
	Wed, 11 Nov 2026 18:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB77C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=jmYHQ7rQ;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=OLEqGKP8
ARC-Seal: i=1; a=rsa-sha256; t=1794422555; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=k5S5Bl7FubLTqmU88nzo26Kl2dj3Ric2T9t/lXXPVJUSOGaBoOUTYNRvlCE0GXtENS
    PwShzJgYoyYfbSyR6VFoAx9u4XFE+DovYYdUiB6hrZRzqP3RI5+bKhF2teMAeuBpiLiS
    k3NtZX8EKFZvLC3znDEDmcgn9/2PBDDz/T+j9q+oK/gcgxWVZhN4qcNH35h7Aa1nPveE
    Neczv3DZPTSkhi5HpalDUPZWM5itTf7iW4ktHFjvMdHN/a/20g1QUNlbJNtvZ1DBx7sq
    I4JvbArqpqamUXBMTZ+cA9VFcDMEMAzEW0Szq6iTGi7i2hntIQio01++ib0i5IT+s4IR
    2ndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794422555;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=UZdwgTcrfuIpSYM1gCDi0i+eUgKIG7RMooqWvyPgmb0=;
    b=qqE4aNze18q/ZYxr8rJ/Tgv1m66+qNTukUW4Ov8qGQhl2NhLDGHXhul8NtChqMmkiU
    4COoL1ZPB/u158J5k4xSDus0cqTnpB6soSAw+ZqS5P4PiFjikTxUvgOtXFoQqAhjxi4t
    cGL92dIlj7u1QqOY2vHfP5ieyOdnJWkUD8DFBleW0tPQjGbEBsNysFtn7JVsjWgB5bH7
    NJYQkdENiK74ZDZXK0mWmDgOXcVkBv6t5o7nWk+zHQsMpqMx/7/6EmbP8Stx+qERb/3/
    Y8qgSUU46orLIub72I6lHe6olJxDEvM1Y5EEVyuU5FKWtBdt0L/y3KUvNrd8EVPxRu/t
    p5eA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794422555;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=UZdwgTcrfuIpSYM1gCDi0i+eUgKIG7RMooqWvyPgmb0=;
    b=jmYHQ7rQSB1Tzj6fEt10Cans6f1S2Z/WT60scHlWjF5u2f2zH7jv8TWFr9ZtT7MoiU
    8jye9bGwCNT0aKKOcSr5Wg8XBzkEIzzI+8mmIwo1FZnJG6LZfOVDuZqFkkyUU/umHWIW
    Xpbua6wg8Sd+8rOlpwtPGB6lHuUX083ldYTGJ/GHGT8Ch+6EWSue5iytdDGwrzfO2dXY
    2QxmLvlAnuoimqjYiifzTl7hQxXKNaqtp7ggE7rGG69Hz40JgP6h0YzWe22Z7KCIEdNy
    BqIzbI+c7na3DTUHzV/7c2+qDr3BxIeYhcR7YmMqLCFf0vj06pcjQf/5g7xMar7w2ZCF
    smsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794422555;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=UZdwgTcrfuIpSYM1gCDi0i+eUgKIG7RMooqWvyPgmb0=;
    b=OLEqGKP8rL1/Y5mfkMu8X03OwrUS8pT8L6GgGyaoLQtNjvsfYzZf72RksCFZEIXI/q
    SMX59KF0dnEg5mSDbABg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+r+eHzyBFvc/0mM2I80og9K0iXpLsCzk="
Received: from p200300c5872329b218616a30d22a9174.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2ABIgYiCS
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 11 Nov 2026 19:42:34 +0100 (CET)
Message-ID: <b2338a8e84366980f648b0e321e9f8edaaf633a9.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Register the RPMB bus before adding
 devices to it
From: Bean Huo <beanhuo@iokpp.de>
To: Alexey Charkov <alchark@flipper.net>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>, Bean Huo
 <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, Heiko Stuebner <heiko@sntech.de>, Avri Altman
 <avri.altman@sandisk.com>, Can Guo <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	stable@vger.kernel.org
Date: Wed, 11 Nov 2026 19:42:32 +0100
In-Reply-To: <20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net>
References: <20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net>
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


Hi Alexey,

Thanks. The code is correct, but this exact failure is already fixed in
Stanley's series, which has been on the list since September:
https://lore.kernel.org/all/20260914144910.931518-1-stanleyjhu@google.com

The order there matters. Once ufs_rpmb devices register again, which is wha=
t
your patch does, two bugs come back: a use-after-free on host unbind, and
concurrent RPMB requests that get each other's responses. Stanley measured =
both
with KASAN. Patches 1/3 and 2/3 fix them, and 3/3 turns registration back o=
n
last. Taking this patch first would open that window again in mainline and =
in
stable.

So I would prefer to drop this one in favour of the series. If you have a b=
oard
where RPMB fails today, a Tested-by on v5 would help, please have a try
Stanley's patches. thanks


Kind regards,
Bean


