Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEC347A0A9;
	Fri,  2 Oct 2026 09:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932496; cv=pass; b=UNtWHPgLalmLh0WnQHZhoUtPB03RKg3PU6RHEK/N5rZPpToCNpW0ythoj2cQPZCnTCQsUTwVB8iKFvFG4phvGV18oVnCua0upxmKRuDMYiddCv95rMtpFt8THYu+1eUGOeAuVBabZJrdciAZ+2HMohg1V5B8kyWoroR1E/ZMwwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932496; c=relaxed/simple;
	bh=aZD/WWbCagIWvnugvFyT7HKRfZAszlcZ/WyLCMkhVZg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I7h9QjxBn0TQtXktnHOJpfuy6rFtu605angJPPkyFlHLxs6Buwz3TkflI6fOHi4AiI+mdoji5BdBTehGPSdk2VLUIZSC/Yapo/bQTvXtRMK1wtGLFojxRh34idIVH2Q0xCJlRTdtsS1H6jGgR4dHAFnAkSdwre5tXxoYD0lNlPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ijVr4ONU; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=sbViJ5Rp; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ijVr4ONU";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="sbViJ5Rp"
ARC-Seal: i=1; a=rsa-sha256; t=1790932491; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=JMOe/9EmF0TT8/33fV2nrRYu+pe0028j/vp42pCL5nYfhs0dgUXlALKmLrExr+uNAM
    hsMyW+KukACMYW18AYO8Ks08JSXGBmr3QP5Xp8NNqDXSyR6v0Oxec1vh6mBL1Lej3i6y
    gYy98a8IyVLM4fiWLAmFBX5z4jpFZdD9Arfb1j08OlfrlMMBdfx/JYJeSK8dByhAV8NE
    1FNUIPcILvAgA2BpwLcVRjrT/QwMM2Wr2d4Uq0Ljthvyt6dNjpwQVN4jI1Ksfkb5nSOv
    M1khGuxcy3KITHA2+uml1gkMluzSwBXPPN+GcgrOD6jphJll7Mmady21pJedpg+O77ij
    mlLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1790932491;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aZD/WWbCagIWvnugvFyT7HKRfZAszlcZ/WyLCMkhVZg=;
    b=hpylgff6FntcEAD/Or0e0pDORagVQ+F+ztj6X0Wxhu0W3in0ZMiYMjmw4W+++3BrW+
    qVSukHopyM/5kR+j8ciM5FZs8YjSnbenT4u2vWpgfQwj+uOYJ6ulxwr2bdfhE25gdyMu
    5eSrssLchsoiox2oa6E1k0DKyJ0umbFsMaeA5dqpYHWyhktU0DWnLTK7vkoscYPDlX6e
    Z5pgvKLJVHdXYee/PspbM/oUPdKs4dzKOR56kXIx0qCBS6uhvNmuH2M5LAE3D4nFKMLr
    gTm0OqJnPGeKGs+cJE0SCZ6/bPjQ6t2ZulXiLf8NnSo6HKsH7ib3e0xSoawaTzt5c8Vl
    JI8g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1790932491;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aZD/WWbCagIWvnugvFyT7HKRfZAszlcZ/WyLCMkhVZg=;
    b=ijVr4ONU5QDiCgPE00k6rgumjf3v8DADf7V9VpqZ/aBZTiiOPb41i+nn+17mCHyUvp
    R3ECrZ4jVDiNaDzIy2rjAY2QBEW9lQDXhYPH9W8VuPX7KSmxfCL8XMSmz+Xc6FbBpj6Q
    WMxP68utQ/RcdX57oIeuGnPT35oU7qWCtOR94XQLAXag+OAlJ2khiheHItZtKOmTon6l
    dKTL2/lmbtzy/fEwEuqXymy0fFP+VxObzlJDNyriyUMaUWcVEcvicWuGsjPJ2ZctcIN6
    zCDj5sBj7+7ss6IfR+24AchRBFxgP0ET4jyg0o8lV5OSRzrjF7zCY1i2ad7GTca+6zou
    cOMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1790932491;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aZD/WWbCagIWvnugvFyT7HKRfZAszlcZ/WyLCMkhVZg=;
    b=sbViJ5Rpru4vjIIvYs7if9qVFCH4ipDbG4a6XWNyncXjGUDAOVPyK6JWZo1QZTeD81
    FLB+os+NP5LHusBFmJCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.237.249]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c2929EoHOT
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 2 Oct 2026 11:14:50 +0200 (CEST)
Message-ID: <f15d5c2df2ca02a8429a8263e63f915b2f2c9bc2.camel@iokpp.de>
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@sandisk.com>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>, "James E
 . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Oct 2026 11:14:49 +0200
In-Reply-To: <20260930135947.2339918-1-stanleyjhu@google.com>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-30 at 21:59 +0800, Stanley Jhu wrote:
> At Avri's request, remove him as a reviewer of the UFS host
> controller driver. The listed wdc.com address also bounces.
>=20
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Acked-by: Bean Huo <beanhuo@micron.com>
