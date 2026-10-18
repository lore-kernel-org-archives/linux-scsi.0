Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A775361952;
	Sun, 18 Oct 2026 19:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792353197; cv=pass; b=jDMTa2M1JIzunkOMAPmHoTtkDtRmaO1QVBMDF/D0nSBMrPWwuU+Fn0u7fLPUUulbub7sCJAMY20idn4jAsRODR/RA+GolMC8GN7hdsRi8RZ+89V4pp7P55ZVkfvjhGerOO7N/mZ/QnGm5GfFjfnFV521qNjnnBsES75Xjt+Z4r4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792353197; c=relaxed/simple;
	bh=R3o4vMzUrYsL/RCUK4nSgjcaLxI8VJKT2cq2tZpXVuM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RsEoOglg/wHGjKKMyyfP5tgpDJ5QpnTj3OVFypV+G4bXOjNyCyq4ZgOM1K90AKIfov+dSKUW8hwOQTCuyrx+DZQyXCgMShlS0bhsnYVQkU6uIgXtq+GAbHc8z4G9Xuu+TOI/gVspisE+FRyCe96HFa5EM9UGBi3X5akhvivIR1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Y2BrKIbg; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=jhtCRQ9o; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Y2BrKIbg";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="jhtCRQ9o"
ARC-Seal: i=1; a=rsa-sha256; t=1792353152; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=pPrYrkTg4DBc5mzZJUr1NvUmqXcKtYwIVsjeh61gTMPjyWXaBuTlEhubKm8OqsL4DQ
    8Iq/pG8TV2lghnKF3bGso3lfYFN4/NXqxtMEAlPXhLVtYCtE6GbNzRx/RJ5pWixeHLtp
    VExfbM/Weq4bKIfN4dFGYSmbpElgjJRNsm6+iUazFCngsZVFLhTZKFn1807o4U+60UwK
    fDp3znGEWwo3/krStL+XTLo2bkKEBa43P5QHyhplsbhBLOIsGLZ0QkfpVgfHcloDmXzX
    RfKm/dlWPmfVpFZt1IIdOtO0X+1GegFN+df3FWvXbTo4P64AbRUeI8rsQtxXgQwzNxCq
    T7gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792353152;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gC6qHl1B+V5o14yq+og01fIcLFwgTL+54fZf+LvzfMs=;
    b=fUg11KG2fZEhS3F6UHoBQv4LD+dbvBXxRXbLPqw5RFnE5wLxd4+CbnEDc7gtWPp0EE
    zq4Og4qq8Fxnmx2AnRDbPh+VDVcNXxaknT6tfoODp6uGe8L2XsQ5rb174AOkEFpA/yCd
    Dk1SCL0wcM3Kc4MA0NyKfvKGT1/rLjxuerih3+ST68Knbn9FbefDUHrtpMbRhXXQoA1E
    irnriz9B+CFcQSs/T6GuOOga5aGYbKDAhLH3quCzerAqvESviL/rsGFFcjYBrSXyZn0N
    EDUxOuhNSQwkutwJhH8HASU27kSw8/6Tpy9AAi5S2vSvcMW9JFriz+bghV/VTx9fjwmH
    w1cg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792353152;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gC6qHl1B+V5o14yq+og01fIcLFwgTL+54fZf+LvzfMs=;
    b=Y2BrKIbg6yLYG/1PMSz6sY3P9ad4+RXLIXIUqDidl+vVPasZ7iNcq3m+VlO3vRkDrk
    /StZLs6XkYjWRMJnL880MIVzjj3rgft7saR1SOuWHJ4SnXxfASopF1bap91suOh0j+rj
    gxjPXMb03iRsSo7fSyqMnebBG701bspkyGApFt1sOwevIGx3sRRURbPI8n6BkOHjU9Sa
    0aMhDeIbJpWgHIXN/H6WiUFoHZ5VVbjBq3L3mbhxBSLgx1z+lTdc+5L4NJ75FKxrMU5b
    Z41CQaH9/SLzaaIIz5uKODx7LsMuscggtdB2Q8kU/Kif5kXQAoGNFJvYHtTBj6PZFs5e
    ukdg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792353152;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gC6qHl1B+V5o14yq+og01fIcLFwgTL+54fZf+LvzfMs=;
    b=jhtCRQ9ozemKiHn1anGVu1eFS/1d6H66F0uQkYmHKzfMYXSsciaufKmJatqqybkp3Y
    5TcZcCNx/1YWlFInIXBA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzZge/Z0bJo/ZKBs7IP24cD2xnjN93xVc="
Received: from p200300c5873684d949ea70d47c97a062.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29IJqVHQk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 18 Oct 2026 21:52:31 +0200 (CEST)
Message-ID: <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,  linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bean Huo <beanhuo@micron.com>,  Peter Wang <peter.wang@mediatek.com>, Can
 Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Date: Sun, 18 Oct 2026 21:52:31 +0200
In-Reply-To: <20261017084403.875420-1-stanleyjhu@google.com>
References: <20261017084403.875420-1-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-10-17 at 16:43 +0800, Stanley Jhu wrote:
> In Single Doorbell (SDB) mode, ufshcd_clear_lu_cmds() clears a transfer
> request slot in the controller and completes the request without
> claiming its bit in hba->outstanding_reqs. A subsequent ufshcd_poll()
> call sees the stale bit with its doorbell bit cleared and completes the
> request a second time, causing a double DMA unmap.
>=20
> Patch 1 adds __ufshcd_clear_outstanding_reqs() and
> ufshcd_clear_outstanding_reqs() to share the bit-claim logic across
> ufshcd_poll() and ufshcd_abort() with no functional change. Patch 2 uses
> the new helper in ufshcd_clear_lu_cmds() to fix the SDB double
> completion. Patch 3 uses the new helper in ufshcd_eh_timed_out(). It is
> a follow-on cleanup and is not needed for the fix. Patch 4 removes a
> WARN_ONCE() whose condition is always false.
>=20
> This series is based on mkp/for-next (db8b4d2bf2d3).
>=20
> Tested on QEMU ARM64 UFS in SDB and MCQ modes across LU reset, polled
> and interrupt I/O, and task abort without double completion or DMA
> unmap warnings.
>=20
> Changes since v1:
> - Add a helper for clearing hba->outstanding_reqs and use it in
> =C2=A0 ufshcd_poll(), ufshcd_abort(), and ufshcd_clear_lu_cmds()
> =C2=A0 (Bart Van Assche).
> - Convert ufshcd_eh_timed_out() to use the new helper in patch 3.
> - Remove an always-false WARN_ONCE() in patch 4.
> - Link to v1:
> https://lore.kernel.org/r/20261016085403.1711740-1-stanleyjhu@google.com
>=20
> Stanley Jhu (4):
> =C2=A0 scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
> =C2=A0 scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
> =C2=A0 scsi: ufs: core: Use ufshcd_clear_outstanding_reqs() in
> =C2=A0=C2=A0=C2=A0 ufshcd_eh_timed_out()
> =C2=A0 scsi: ufs: core: Remove an always-false WARN_ONCE()
>=20

Hi Stanley,

For the whole series:

Reviewed-by: Bean Huo <beanhuo@micron.com>

One more place has the same problem. In ufshcd_abort(), the "cmd was comple=
ted,
but without a notifying intr" path completes the request but leaves its bit=
 set
in hba->outstanding_reqs:

if (!hba->mcq_enabled && !(reg & (1 << tag))) {
	...
	 __ufshcd_transfer_req_compl(hba, 1UL << tag);
	...
}


could use the new helper in the same way as patch 2?


 if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
	ufshcd_compl_one_cqe(hba, tag, NULL);

Kind regards,
Bean


