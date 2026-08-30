Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9217625B0AC;
	Sun, 30 Aug 2026 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788104840; cv=pass; b=nSAGygSEuM1OUnPQobb6J4MIxU9GQnbIsKbeWwJlSPzFG8vvUVdewol/JrkjwnaWKhVcKt8r5a5hCZSKbxZfAQ+A1eF0NEfxWdtfxglWvDH1jL/STmPqVDWv7RA2QrLj0yChbPFbPD0LW3qpDHH0IvKBMtmNKLHpaXOdqvO8kgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788104840; c=relaxed/simple;
	bh=z2m01tKlkKHlaM/0IXx3sQbwCS88IIrV5vJiFQBhVbI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IlonV3gZTKkVJ9cxxAzzxRF4O0V0u+LAKRN5l6CZtHFh+TiL7ZIikh49zVNVS9MRmigK524aB7y4envF7J9Baqac2gD/19JgPqW4x31lzp9oCVa+k4v2qFkAWjfWaGgIrGDkFB0UdrhMjW8k9MEiyAHa2vlYyQez32HHrD5rqC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ngkf2WV/; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=h6Z8MQty; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ngkf2WV/";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="h6Z8MQty"
ARC-Seal: i=1; a=rsa-sha256; t=1788104656; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UYmDnMqEHTl4rYDHkmoO6PdkWPzzGACfMgsSbl/R4tNwjr1G5h2H8aWoQa1M9yKkYu
    UCTrQTF0jD1GCPQCluzI3nbg1T/vhZaLSYRPXpb3i7dNNWmg3aT2/EOoveD0cBJ9FaMu
    2FfEQGasrvCDZpD/CMl0gF8nRrbwBrGMg7boflqswvs90tPdTEGIKVnhbv6n/s4Ryaph
    lDRSnCOYe0mZoUNLQJ3dk+mAnfUvZc2kI32+yRfax71qJS3WG+y5CB1XFAjWQyAhZue0
    H55l8/ddkJr2ATvolB0IcHkmqTMuqkdvdErgBiHv4WYAdGbPzmxXqeCP1mBGQM/jpA22
    vBEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788104656;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=z2m01tKlkKHlaM/0IXx3sQbwCS88IIrV5vJiFQBhVbI=;
    b=mDUdXC5CFE/R137N7liXkn839asvGfEE3lMidgqTsNrOFY/7bXSjsVGHJY0l81hgmK
    JGkls59WEzgi9TxbSRKtoEdgbByFjifQ7nc3hXv1kFb4PR8QOXqVqcbtf7MXB3x6ZcOd
    LIG1E2dm9HZbU8pFbhz4PeruuN7wkUu0aeoK7VdAqfZvQUPcevx7UMDHm5/NU25Zd0O4
    SbsZJVXl9NudETKhQ+IARZsrrGGdgHeAxuBAxS8ATmUFOVp6ycVt9/CDrbEphped+2gB
    N3jdTfZbsPLt/n79AoZPNGsg4fqZ5rl0Z7RIfkT4b3xP635TaRacVsBYekMcL5tz9iBL
    M8QA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788104656;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=z2m01tKlkKHlaM/0IXx3sQbwCS88IIrV5vJiFQBhVbI=;
    b=ngkf2WV/1/liM7L66IfArmEQHa2SGESNiHkMA9RleyNmSf/otueoq6bnalT8LWc/DS
    i/yByp83JLOrbru74+7Ir9lHvqbAet3BF8jr4ahvofX6z/GV/9lOtDhexniSDbkl+1f9
    ZLwL3kyT3/rjMNhey087teemy3MOA7gpsNpiBscYQWt3tAtWtMEb40jjoTNQXD0LuoJL
    aAm6/qF/3mCgNKLfkvdze7W/xojszEqkKhULO45TsDG+iTg096srvHiUUvOXPesCHMsK
    OcrQW9zPrO6otmWC85XoRQZqxvhtMI2+73b0Y7wWuAEHPQjQhwDwZcwJuSz1pFyml4UD
    GDfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788104656;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=z2m01tKlkKHlaM/0IXx3sQbwCS88IIrV5vJiFQBhVbI=;
    b=h6Z8MQtyHGi9/ITjy3HNgiSPnYk/Xim/QJBCZ9XlGuV4LgMmzfz7vtkNVyYn7jNu6v
    G2+OPqaABV5CPhbTpPAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/4y2xJGqxKO/71WLEX+9Og/eiUqko/dE="
Received: from p200300c5872968993aedd1469d684940.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127UFiFgif
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 30 Aug 2026 17:44:15 +0200 (CEST)
Message-ID: <3e9b0d90733b6fdee6da3f1acb7c91c320ac2179.camel@iokpp.de>
Subject: Re: [PATCH v4 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the
 RPMB WLUN
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com, sumit.garg@oss.qualcomm.com, 
	jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org
Date: Sun, 30 Aug 2026 17:44:15 +0200
In-Reply-To: <20260827070345.2853821-2-jorge.ramirez@oss.qualcomm.com>
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
	 <20260827070345.2853821-2-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-27 at 09:03 +0200, Jorge Ramirez-Ortiz wrote:
> After a power cycle, the first command sent to any UFS logical unit
> completes with CHECK CONDITION reporting a power-on UNIT ATTENTION.
> The SCSI core surfaces this condition to the caller rather than
> retrying it.
>=20
> For the RPMB well-known LU the first command after boot is the first
> RPMB frame, and RPMB has no earlier, guaranteed access that could clear
> the condition beforehand. The power-on UNIT ATTENTION therefore reaches
> RPMB and fails that first frame, breaking RPMB on every cold boot.
>=20
> The RPMB WLUN needs the power-on UNIT ATTENTION to be retried so that
> RPMB works from the very first access after a power cycle.
>=20
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
