Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6C4224AF2;
	Wed,  1 Jul 2026 20:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939134; cv=pass; b=lT8FM1EqXXVPsYwL/ji3jVkYrAomzq6xdLOi1k3FQoJ/EeU7xfuQ+ZuJbo+Np+6MIyW5CJpJp0c/q5UXF9edNdTrAAih0N5vr7kv0PZ0uQIIvl5Pn1DwYm3fez9rlqKbsS1oVkY2GEw3J72RRMJ8cWL/Jkk9S1oALb943qTZYXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939134; c=relaxed/simple;
	bh=0OI9r+oDLNMoCCNp+jvgl6P08jRKSfU7E7aeuxBZlOQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Htfdxpbf14dL3f6g1uni5FI+jScDBY8D36Zl4vZclQP1e4SH6CtiM/3+jwljaNjClDRDZ9WfH9Ke/W4LR6iiTUSDJFr6TtkITgZLiTGVegc+JnjsuTmKJBZY6oCs3+l7n++H00Chud0xPOY4EsWmyL/jtNZl9pxfRt5i97D3J08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=sIai4biI; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=tHf9G+j3; arc=pass smtp.client-ip=81.169.146.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="sIai4biI";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="tHf9G+j3"
ARC-Seal: i=1; a=rsa-sha256; t=1782938946; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=OwFN0gPD+BiuM4H6omziC9HWaxRyCyapRT2uKi9EFb7YL7zfTa4siBw6pjiqE/E2UW
    /9Jnw079GPsGR2Dd0YfwoAv4V86rwJw+vRzkK3k86qBWC/iJeM8/pun8FvFuuxXYTkbW
    PTsmffApLXWk+ZD1L3mhWM9OCPcFEKMciwrK/L8ZTSPJkJ3nrrik496TGRewLL3LtX+8
    WHeaPZZ6DojK0KUhJKp6ENyszQrAm6cLORJrJW/5+DV1g8e+nKCPiyqHwB7n9aPWN0Et
    tnh0hK9lNOAIvjZzdRKLgnjFDAvj8JAK1k7gblXsCoRPi4Z4kVa/o5Yh3H2QDM1ezBR4
    zOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1782938946;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=0OI9r+oDLNMoCCNp+jvgl6P08jRKSfU7E7aeuxBZlOQ=;
    b=HdxzqBaRCHSC8u3tKtwPAL0ctTU1/AVWXlIBgGV9h+RnuRUZZDw/0k/X13tuf7EtDY
    /Rr0wzdZRFpxUPYxdJgil1Y/3ClsS6LlJ6PmKuDUgvMrB8i8reRXpDcaMXw0+ly+22OE
    1z2jnL+pxkFmGAgv4MT+LndKUh+W7oM5N9ycbcFIJaPyd5+PmuMQL+AouE3iYufMuG1j
    MMXXTtlMx/SCqovv7WM1qLePnBNzGl94rhiauUFZqQOf1lNhO5S2diJDUHBMiumWpbVj
    zRzuKo5ehy+6cppXJP7zQEfW3lykUpmKRdroa+/fakg1hfh2/nt0b1bRw4T+B+0gd+DR
    RO0g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1782938946;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=0OI9r+oDLNMoCCNp+jvgl6P08jRKSfU7E7aeuxBZlOQ=;
    b=sIai4biILPLJ3qx6cnpm9RRIVP5MADxN2cHXM5kK9ofXpRkcri9XD/IddbgDCMEYFY
    Nucj8fnxifKV2l8OECinbLlPVfMjK/xFKoIW1HlMEF5tZswCxIp+OKC+35xggA8qbeBM
    cbi1mA75/rXPK/M/Wl/rymRoVdkw1CXAwC0u1e+JkIFKYqk05yYtZCPv3glH/hYV6SUk
    SolA0aRAaaj83QrkXMLAVjSbwYTZHAh121nyyWTwuKVeJAjBLgILocbkGh704GCeCeLc
    l+heDDEZnDcCIRLD5i0MB0N58Qsz0tt4E/j3gZDU3yF3GnkvNBzrjIPzA80ua6BzzZyH
    z2EQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1782938946;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=0OI9r+oDLNMoCCNp+jvgl6P08jRKSfU7E7aeuxBZlOQ=;
    b=tHf9G+j3iVW3fB/gSnpgkz62pZdUbJLh5lze5IV0e5jjCcfBXOSjuB23+y5f7nDk6j
    UBBbT+xn4e5QQR33KQBA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGWUpI6weUrZX7j5d8vw1ZwljKUZAZetExYucA=="
Received: from p200300c5871477310ac0be5030e43536.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d388261Kn5VQK
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 1 Jul 2026 22:49:05 +0200 (CEST)
Message-ID: <3362cec069bd3437c378f356c3e1333d3428070e.camel@iokpp.de>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Always run tx_eqtr POST_CHANGE
 notify
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org,
 beanhuo@micron.com,  peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <avri.altman@wdc.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Matthias Brugger
 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,  open list
 <linux-kernel@vger.kernel.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
Date: Wed, 01 Jul 2026 22:49:05 +0200
In-Reply-To: <20260625121306.1655467-4-can.guo@oss.qualcomm.com>
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
	 <20260625121306.1655467-4-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-06-25 at 05:13 -0700, Can Guo wrote:
> ufshcd_tx_eqtr() skips POST_CHANGE notify when __ufshcd_tx_eqtr()
> fails. That can leave variant cleanup incomplete when PRE_CHANGE saved
> temporary state that POST_CHANGE is expected to restore.
>=20
> Always call POST_CHANGE once PRE_CHANGE has succeeded. Keep the TX EQTR
> result as the primary return value, and only propagate POST_CHANGE
> failure when TX EQTR itself succeeded.
>=20
> Log PRE_CHANGE and POST_CHANGE notify failures to make variant callback
> failures visible in TX EQTR error paths.
>=20
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Loods good to me!

Reviewed-by: Bean Huo <beanhuo@micron.com>
