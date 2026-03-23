Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6186386446;
	Mon, 23 Mar 2026 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257122; cv=pass; b=VjckcPTPN6nS0ChWnyCgeJkEh8tD3PEldgN3HHd52Qeffckdi6bKa9npLVipvG6omeDyMpo2XxzQb7UgrZccgM1VTfDjS7yWZz8MpSIZRU8riN9HfT4+1m/HyMbgbSEhMoDeuQLkLYAfqKEPv8XAIWk5l4tuWQdKjPlUEuKbZk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257122; c=relaxed/simple;
	bh=ik4ULUcaq66QXFC4tqsx+KdeuSY+P2gUEGY7Hp5Q1kU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UeEzikLlE5leWRq9aWarodXGx0WgnETZpXpfeoC2VojYkzu7Qrm9/giXQzUwr0fmpc4j2nLXpoF9Ly71HrPlua1mb1au2WQ4+KpAupRyLNyGL3+JenT3OknE7qz/D0hNWQoQG05COKGfbaUUTDp3Yw50jV9DDvazDyeMseW5YNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Ljyt5l3F; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=lMlJU4ly; arc=pass smtp.client-ip=85.215.255.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Ljyt5l3F";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="lMlJU4ly"
ARC-Seal: i=1; a=rsa-sha256; t=1774257112; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Pm314NDnRWtPTjYGKFjMH+46trSq5ezXOGQ0516coSapKllby9TAu1fuIaM7QWS7Fr
    A7c1DsyUTi82wCU7PFE3uTmblk+WTm3Ml4E8ez8VC3JJn5yQNQC/8vejEExAZizDmkLU
    lRpVQFY5wM2fL3PtQ+BhzlSVc9yfmK9hgIblBUkXZ8mFcSxOccJNMsAT8zh1VNw6b2Kk
    1B69jM/S7cSXn3prIiLsumZ6di5mgRgfJSrQllY0tMC5Jp0pj8bnibmFehx/9dKYCvLt
    ag2mAYOS6whOkPqB96N429+mR7pKQx8oqWg7XZk350juguiOmOH2g3dBxeP0v9WxgacZ
    JXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257112;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ik4ULUcaq66QXFC4tqsx+KdeuSY+P2gUEGY7Hp5Q1kU=;
    b=J6rTslTpR9p6MdK54/rTRbRlhyld92ks5v5f+h0gRaUiZmZDjyW3yJX7BEDA39O3E9
    jwxLPTan9gKo2H7OS8dSKenYWqFwGCOG5xYSOpiIf0+flrUZ/OiPLqIyJs9Yw8QP2xCt
    oPCF/Q1XP2tzCGPr93YHiLik8Z8G+NlfvesMq+RSsiNhbkr4UGieBGc6YrjcC99wQ1fN
    ZGa+vev91ahxEzaM+upXuBFM0IhLNAD01lDseLw8ep+YRB1sEFL4dkL0a0/GuEnu/2TS
    0HOJxUubICcgXo79YHRWLzBRNWln80a31J0IQq6TG4I2X8E+S63ly2+0EXrDipP8vKzB
    lKsA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257112;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ik4ULUcaq66QXFC4tqsx+KdeuSY+P2gUEGY7Hp5Q1kU=;
    b=Ljyt5l3FbDSlUBaArTmoUmRtbzg7uWdplbCJ9/IVsj//QgwaLJT2gYsyhDFMx16nrv
    5cLMssBCQ5k+ToXKuymHqce1zfMYo+e3Ik6Jt8wcp29xyv+mW86dW5MPuTHCPODKSBxK
    7HWgqhLjtASu4DiZkH99DkGdjhgWEuGFzjEW2XwgpP4R6/+c7Z0J469uSEjqjwOTOOkH
    XyLPHQulg/FT9peeBj6nsgfQBlUYcQv/bsr0WxuTu+pszNI59vrxtimrb4JygJXSY1TD
    h/XxXPMRyDk5wQG+CBv31n4yKcGc+MsfpkQdMVWlqX5vVqYtD22Zjt91YCwGcli4fyNG
    cB6Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774257112;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ik4ULUcaq66QXFC4tqsx+KdeuSY+P2gUEGY7Hp5Q1kU=;
    b=lMlJU4lyygdtM/jm5E7Kc9rMSwy+1qXGykOlC18FGO05agLJqWDFDPlausEDvisxp4
    14XvnXAbgwQ+grvrcIDw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934522N9BpQJn
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 23 Mar 2026 10:11:51 +0100 (CET)
Message-ID: <834218719845605cc146a221e897c0483d858c62.camel@iokpp.de>
Subject: Re: [PATCH v4 03/12] scsi: ufs: core: Add UFS_HS_G6 and
 UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Alim Akhtar
 <alim.akhtar@samsung.com>,  open list <linux-kernel@vger.kernel.org>
Date: Mon, 23 Mar 2026 10:11:49 +0100
In-Reply-To: <20260321031021.1722459-4-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-4-can.guo@oss.qualcomm.com>
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
> Add UFS_HS_G6 to enum ufs_hs_gear_tag. In addition, add UFS_HS_GEAR_MAX t=
o
> enum ufs_hs_gear_tag to facilitate iteration over valid High Speed Gears.
>=20
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
