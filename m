Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [85.215.255.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D47387348;
	Mon, 23 Mar 2026 09:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774258396; cv=pass; b=JuJv6h8/hzx//968yYcMjHtqszrIvBWIgsJpG20g81WhFgzVLdGLwtOblX1qitNfku/ViqSnTVRtX5fvcJiiY13if86kGlbE5XJbX5EEFazxaMBf9sZdvpXnwHInFxvqiV2aS9Lfleg/0WDZO0QWtHhX0KCL0FAxQTWgYBcG/40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774258396; c=relaxed/simple;
	bh=gzfjteRASAmyGFsyWuDFosv9IP+jD/Mjw5vKk/YfCLU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UBZ93LqhaU29x6oV2FhbH2bX/x8yp4+ARnjbugM3yVqLVhgdKzKpsuNu78LlcbIttExgCa2lIna+hPc98H0lcpdqrSVWISsBwbVi4P1Uc+88wFpBNZOofLd2gSnTEU7PJ0uqf4a/38xgO9f4JnUhg3ffYQihY6PzP2ToWhak57c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=s+BlSwa4; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ijWl1/kE; arc=pass smtp.client-ip=85.215.255.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="s+BlSwa4";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ijWl1/kE"
ARC-Seal: i=1; a=rsa-sha256; t=1774257665; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Osya4ap4bGqrB9h0HKziOGT2m7bLzt0T7VLtSQczHaiB2T/u942r+ZtxiN9wa+RbDH
    oFzyHilxIVGHCr5hDaa422WCpdey4OWcmDNnON3GeP9uj3P5WKPnzmzegtT2sjtr8IeG
    JDWnYljtGTY+CFAoD4AFkziVWnlnEnaL+BjQ3uvJlAPpCzu7TrKY+JNgeb+Pf1QWhrF7
    7DZ8+U8rwGUlisiTK/V8l3dUMiZJGJvovpwYfD28WUMoPjK6kaPK0s+0t/PkLfET2fub
    6mfUUN0bg1lqdSOlYcrU/hNRwjPo7vBAXiRtlbZzeRlVG71j65RelfCe8ThGa4Pjkzk4
    G56w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257665;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gzfjteRASAmyGFsyWuDFosv9IP+jD/Mjw5vKk/YfCLU=;
    b=TPw6DZLvumtJZDsRGFiQASg4ngXX1EBN+3O6FaZ0sNUeSHMCgjzl9AIAybB0WwXrjv
    pPnF3kEucvrbNYI2TPSktIZVmsBhRIYrAnz/dyFb3a/vKIBI4hup4m6Rr1JkWXOs4mW3
    1ezWLvDzizhLrAbiyWGIUbGGPLZH6gL31NhUTijoOhVqgme8kE0cZU0JKCe9UA2FJH+Z
    S5HZeBaLc6Vw2LaQW6dHRohv17PcKZ8QszeI6/GnRg6B9GUnozKR+3U4X1RycEPL4VEz
    vmvh7CEe1btjtdI/+WjySZfmVzRBt+iv6k/6HRc2Rx8wtGs4ZWdTwTxgdQypo5vOBIvm
    WfaA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257665;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gzfjteRASAmyGFsyWuDFosv9IP+jD/Mjw5vKk/YfCLU=;
    b=s+BlSwa4056SH+a0UeWVLKo/ROu0sZy7bPj7xTcjov+Ob0RI5muwHlsSesqHXSPmBI
    2zYasQF+pdQqZR0KLzBrt8x6tMlEVOhlz8qeblzc+CEzI45eBqp4XdBS791N+ySydV0/
    rmOxxUsh77DfNgNFrm9fIcUjrpIf1tE3tQuarHO87Xdfmhqomfn/ci8g+0iJEC0FeWn+
    oA1u78HvSKKE3zh9vLsKllFVg73txuXHRFhwYz5rVbFRC2hg7mGY4KqdLTvg3uPwCgRc
    p9yJYmEcse8uKNba1b5eNEnTwXwRnHIzwYO7ImmjMWq6awP7RB7r6IF5ytoVeSlnixW5
    We5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774257665;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gzfjteRASAmyGFsyWuDFosv9IP+jD/Mjw5vKk/YfCLU=;
    b=ijWl1/kEFxdvzkwnLJdbdi7BH30bFJYGWGSZEUBwFr31/FsN5ZBaZsuQGKTWpkCl8T
    sxvV8yRjp1aPa/eNAyDg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934522N9L4QNS
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 23 Mar 2026 10:21:04 +0100 (CET)
Message-ID: <7bca14cb8560ff16cba67ca025837a8b78e3a8ea.camel@iokpp.de>
Subject: Re: [PATCH v4 07/12] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter
 <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
Date: Mon, 23 Mar 2026 10:21:03 +0100
In-Reply-To: <20260321031021.1722459-8-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-8-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
> Drastic environmental changes, such as significant temperature shifts, ca=
n
> impact link signal integrity. In such cases, retraining TX Equalization i=
s
> necessary to compensate for these environmental changes.
>=20
> Add a debugfs entry, 'tx_eq_ctrl', to allow userspace to manually trigger
> the TX Equalization training (EQTR) procedure and apply the identified
> optimal settings on the fly. These entries are created on a per-gear basi=
s
> for High Speed Gear 4 (HS-G4) and above, as TX EQTR is not supported for
> lower gears.
>=20
> The 'tx_eq_ctrl' entry currently accepts the 'retrain' command to initiat=
e
> the procedure. The interface is designed to be scalable to support
> additional commands in the future.
>=20
> Reading the 'tx_eq_ctrl' entry provides a usage hint to the user,
> ensuring the interface is self-documenting.
>=20
> The ufshcd's debugfs folder structure will look like below:
>=20
> /sys/kernel/debug/ufshcd/*ufs*/
> > --tx_eq_hs_gear1/
> > =C2=A0 |--device_tx_eq_params
> > =C2=A0 |--host_tx_eq_params
> > --tx_eq_hs_gear2/
> > --tx_eq_hs_gear3/
> > --tx_eq_hs_gear4/
> > --tx_eq_hs_gear5/
> > --tx_eq_hs_gear6/
> =C2=A0=C2=A0 |--device_tx_eq_params
> =C2=A0=C2=A0 |--device_tx_eqtr_record
> =C2=A0=C2=A0 |--host_tx_eq_params
> =C2=A0=C2=A0 |--host_tx_eqtr_record
> =C2=A0=C2=A0 |--tx_eq_ctrl
>=20
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Looks good to me, happy to proceed.

Reviewed-by: Bean Huo <beanhuo@micron.com>
