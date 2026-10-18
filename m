Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56136401A01;
	Sun, 18 Oct 2026 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792348268; cv=pass; b=n697it3i9i1oHanNdtpD59BE2rxjjDvCJtN9RF6zHWUaH60j5J1kGnWTNfBFlYr3ZyRLZ40BhIoDUe6+laOtQMqL3n3tIu0KreCM41RD7cJru62qEQjyEZICFIMXhpnu0lUvcqg4OZm5qDj5sAZDKHJNLAVRginTvRrScYdLhNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792348268; c=relaxed/simple;
	bh=brh6yNBdblpym4G2uBbHnDBtyg60bFv4UJ9fWRHWPMg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eO45+Up0N+m4HP5KuTED1ozPg58DBPBlWO5OZngdZ7A9HsRM5QzvwsDNdgzAPDS5/qnfnQZi9wDvb1v4ZCh+XCiCMtxEeHSdmX2DgZAQT/O7iyq22tkXoK370RQezD+ThzC2Gwnfbzl4euoqkG3DDgX//jTJ6mwRXaiYenb1H1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=dKI0mtXJ; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=slna7Swr; arc=pass smtp.client-ip=85.215.255.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="dKI0mtXJ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="slna7Swr"
ARC-Seal: i=1; a=rsa-sha256; t=1792348256; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=NpjIZkChzE04DC6ZKLfqlvK7ZolUOwl4KvHT4BUVc1wTpTorJ56KSHMiDYCN8XLgxD
    ntmxNwEaiGciNJb3pywFAC+iglvO3sMeeisH/0y5dWSf3wp+XU4uP9gjWijXzIFcKrmn
    nO2crriuYF4DFDx8bRXfmMnKg/QmPvcwWin2gDmv3LAEuyu1f0VqRMaqi9kB+H50Ddgc
    VmroxKtuLGv/gS09k5809es+R7G9tqrZRLiD/v+2WXnpCKz8LiyNMSNbdsIYY1wRefB/
    N51pbPgWL1S0ffNmLF2BI+vgFhultXkMxyrUxZt5zEE4tmAztBiARa8lzYdxowzthvxE
    dvDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792348256;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=brh6yNBdblpym4G2uBbHnDBtyg60bFv4UJ9fWRHWPMg=;
    b=O1cBgCwFkKuRZiR/GYS95hLX1uBxVkKOm37WvvnrUVdsoy/I2lNCocOrmX+W2g51R6
    Zfb1N13rYnteQQB2ESxUmHZF+vnEo47ChZ0ja1SThtwMWEe/0ua4MxoU259e+KpHyVmJ
    L8aVMFBu8gdzpgVTO5vfi+i9qRmMbLYF8A1dlejQiS46crsuv7ntpD+ZgJhLZtLsNh54
    bApBT298rPMQ6Ad69SXBDJjo5VXMJPs3WKQJn1CwtBY2rWV/3ZiYjnz3F2LdNxUq/KMV
    l0T/SCqSRc5fdGwWwFd5xEMxJEtO+j9qYFhrYUYL+tbz6d2dZsk3aMJdKgiR9z2eKIDy
    MJcQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792348256;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=brh6yNBdblpym4G2uBbHnDBtyg60bFv4UJ9fWRHWPMg=;
    b=dKI0mtXJYpPPQQpmgRqTxC8th/PwUWFyeXs/5oUMK+Lbuj54rZSqMhMbCelJHBcbiK
    eRvvFErsO6ysJSdrve0pbEkrwB9nEHo5gUeSaGxXvq0AMcPu9kylyd1799+moITmj3op
    nEdOhK7r3acXM7hU+jMtxEHu8b6aUicSKGbzoKtVzZazKFExn6TbTCO4N76Wdz5Yy+l0
    11Sww86OSiMaGtR/G9Kqf9P1VstOMT8vjrkyIHsdfdP4ocjxVmevA43WM0jOrYky9VVa
    nmeTdos+ygF2Dzxr1tYdedsR/sMzLuy0ngAzdN4WfV/E0tlz45oMA1XiZ7uuCz0/fK7Y
    wcog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792348256;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=brh6yNBdblpym4G2uBbHnDBtyg60bFv4UJ9fWRHWPMg=;
    b=slna7SwrVckrQOfD6tOXf24csNtGxPk0JBgQlsumWIbZsTy/sx4XEUX9S+Rw3DL+A6
    uK/FgetirB+ZSty1iNCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzZge/Z0bJo/ZKBs7IP24cD2xnjN93xVc="
Received: from p200300c5873684d949ea70d47c97a062.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29IIUtHKE
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 18 Oct 2026 20:30:55 +0200 (CEST)
Message-ID: <3161f0a4aa665d4bfc089586f618406418cb1856.camel@iokpp.de>
Subject: Re: [PATCH v2 4/5] scsi: ufs: bsg: Reject UIC commands with a
 non-zero result byte
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
 <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 18 Oct 2026 20:30:54 +0200
In-Reply-To: <20261015001855.3450573-5-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
	 <20261015001855.3450573-5-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-10-15 at 08:18 +0800, Stanley Jhu wrote:
> ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
> including the result byte (bits 7:0) that only the host controller
> writes. A non-zero value triggers the WARN_ON_ONCE() in
> ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
> syzkaller.
>=20
> Reject UIC commands that have the result byte set with -EINVAL.
>=20
> Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in
> ufs_bsg_request()")
> Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is inva=
lid")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
