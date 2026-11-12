Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794489227;
	b=wTs7pBHoZQ7h41mlJXJ1JJg8AdbGCHwtlDjrc3+24a3kLEVzKZZP5oWickIb6StpDclL
	 R81ZuQBOCufgMBeiN6PH1TVgocy1yuniWCdsFIe29BpErCk9VZLop8EIso5WyEvNbJf2Y
	 tOjtwkxV9GUGu5mHt/5qp6CSubTxnlUtyOAj+frO/EKznNl8D4SeNTkwQGrfgz/5cgeHv
	 xr9qY4KusfMJubpN8REE0CcK4BvG68pWkVqPcPiVVi4Fg+wi4WSzz/MzcKLj8mEta+X78
	 KomojL40Ju5LrEsoNAKRmN7WYRVFh3NOW5VzJf97Bx9G+Uk82y9q4pAbyQaemgFj/5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tt+WFRdvrZSXnzZAVznwgbf/IavQw06AhCrvauaK6GQ=;
	b=2qh3NSY12IEguqqvTQ1y0HiOUG4X2zo90nSD4iIaIn13H+ddzlKFKix2tDscNEDMJPBd
	 XdpNWz7ph7y62+F8qFSYA3NXE9Jd8BeGzR/xDxWp3amDpCjkY1i1ecmoTIq3aOGTOohUB
	 vsvNLE5No3hvr9gF5ZMM5jr9JcaO1MUXy5fmyFERerMO85Ji8NTkjPg5nx2VhqvpULcjG
	 +hSuenME5RdX89lMfGpBIpAuaIBU2EYKq26zJS4kiAst9GOJY3ywKDEjK3W/Ss97l9tbC
	 ZDh2YDObmt4+hV0qjrt5N9tDyOzXgnPzj3eAU4IJR8MYZ7LXlnQVaT3WBPhi9youjlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=UIJzlhY6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7EC606A336
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:13:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A7EC606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=UIJzlhY6
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4c9abc1824so600121066b.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794489226; cv=none;
        d=google.com; s=arc-20260327;
        b=fwZHVZmW+sPsnnZnNSgsObh160MTzTDXREOMjMmSQ5+/RQl4VArgFDQaYtUFGRYUOA
         CqRvcm93lNXZc6cIdNa8OG8AMYlmkigU7FXhhY3ZsWw/N2gFl+8Rri43aVTErHtVtRA8
         /zFkgORpxBVxvImK/uOoooZjBJaoFpc4VqiFhA4BTZf9qEiLuVY3wM74q614wWpQ7HkQ
         ovdfX6bCrPO0jkda45QzfRuzs1xhewi30geFfh3pq9uAXC+eMIOqS6MCnN7T6hg7rsw9
         dAonmywtA4FDqhsSjdWQLzAe6usJgMrdZDfBVW/s7Gs278/6XMnU2yEhYrBn+XGDMJaR
         7Uzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tt+WFRdvrZSXnzZAVznwgbf/IavQw06AhCrvauaK6GQ=;
        fh=HrjXsMk9V4hrYWu4EJ+oSUzsTNBl85q6tm7Bjb3cngY=;
        b=HU6z0sC9rUelK8fMaLLnj+EvFAAZlArIOpGNbbttwH/74NDo2TV1AslurBr5iNTJox
         bWu2RTi5W9USLcIlLn0iyA8Y2C547rbRZ7MZTehF+qSpvl2QGfkLQTONLheQZ8RN114Z
         kKXccTub2+J5ILSy2lO92N9dsq0LwaAOoayZCNoqmViOtK1ZXqvcEJtNQTvIpBbcrNaC
         +9ReEu7a3EmZYanj/bVallPVBtjmwvJleKGqfL/+SmfR9qjtTYewheYr/iQeNYfTeXDk
         Dmca4D/g5OvEfZ2R9/chi1CkmL3peOPPS9m6O4INoLKl00V4WqHIuqxMZMbigK/lwX3T
         bXeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1794489226; x=1795094026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tt+WFRdvrZSXnzZAVznwgbf/IavQw06AhCrvauaK6GQ=;
        b=UIJzlhY69Bayr+gzpIOO2ecPVg/Dl5b/ElSR55In6aKYxCYITsRRmqHQkg2aGzopck
         XhZkbzsGBlmiJCKQJaArVHr90KBvTEU/MPReiE3eLnbdIQ47IeB6LEp2REoi6imJG9Uy
         exptp/08eh/urHnv+EN3OTfET0zGOKipFDPWHJJn9wBNaKpmrGQZHcDomLzvBKmO+utO
         TYPDbm34/J0/pW+/HNQJK4nW7o+obIIvJk0vmKX0HZ22pFcRwKG/HEHln+4Kpzo/wtHj
         U7KgVz1pc41IG+o3pLhH7hn0tIwXhqIg5hAlbrxyLp2FCFPNpUFDTCiYPparpbP1Oqtj
         clZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489226; x=1795094026;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tt+WFRdvrZSXnzZAVznwgbf/IavQw06AhCrvauaK6GQ=;
        b=EejZC7kCbflbKkik8bsThtCyiA1YIDlUsvtEVHVDCifzhuJPzfO2XV354vnLfsgnDl
         eOwmhuHaNYMCM0HpPaB7j9xG5fZq+X0UFu+FbcNqxAeNfekxzNUAwKMMvoiwX+VYQNo2
         3hs8DdAzW6kSBRvgYyYs3MvsY//GjAJetKtHbQI2GdES+29vtOq8xZLqX67bGmv+wJWG
         qrRkP2V58pLui+s7PMy1CKRZ6lthbPxpFwxC2hIHyfWMhJqg23j6luljpHhJNQzz83Fp
         wOGPkFrE9tCbgQsWipqpk8nSmvBJgFngPxybe0TQu267K8aJJPrCgQYMAStmTo/eXXb5
         rfSA==
X-Forwarded-Encrypted: i=1; AL+hErFt0lb5HHUvbwBONpcxt8dvKQpp/GNl40Fd6EfG6wl12Dq+HtigTmTEJMAdAcFEJvlZ+SUPNAJMqFiI@vger.kernel.org
X-Gm-Message-State: APuU4Z9vnnxzRfnkWBLQ+6VBBVDSBsgjjaX2r0/5DgmCVoH5+CKlAk94
	LGH6eSUt8QHFbwvKAK3njdYINJDRdYkg+p4MS9EXbqxgUvdU0ycaZ5Dq4PJvqUx87zBX8HS/xHL
	Ag4kZQE6wdB04qYZ1zoIWVbmaOXw93eXsLYpLA4AKWw==
X-Gm-Gg: AYBFou0f56ey/IfPvj5Mv2c3j7808/P+kPjtIbOlz2bMBthT99MMwNwD/a99vKZoqcQ
	2zS1pZBQFeiOoLJkGBIBDFxaWieCrjOmnbBGBMGqr3FbTCovs/m5bZghKDyN5wJTRB+o8WmWAyB
	99+Aow2QOogfznweeWc3RTGig05kJ4XWG/uOo9S3SpbZ0QCR/aXfaJeDCgEq9AsfjxM+qOveKEl
	lNGm3AoHk4Mh6OpCOo4YcRFbmNj8m8FLMfihgUJI3DLw2T8OKfk4E5ZJkprW3D7jMxTpMWvvMY7
	BXqMbPW59mmiYjTXeXYWfONRHNOGU6GSn3JbFsVRmADQgdZDJP71ptT72N6nKeGuYmsEW+6dFYA
	b4lIcrAWQ9vFa8Fm2ybv2NwkfLP6MjmaY4/C1kb1bXvInijlI1k+oG+I=
X-Received: by 2002:a17:907:2d9e:b0:c41:6de7:7dee with SMTP id
 a640c23a62f3a-c506685458fmr461873166b.7.1794489225737; Thu, 12 Nov 2026
 05:13:45 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net> <b2338a8e84366980f648b0e321e9f8edaaf633a9.camel@iokpp.de>
In-Reply-To: <b2338a8e84366980f648b0e321e9f8edaaf633a9.camel@iokpp.de>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 12 Nov 2026 17:13:34 +0400
X-Gm-Features: AclHuK83OfRmcNSAr3yNNJR2smWwrfyR_yt7neFWx9UxX0YmCS3qGDuhZxsxCk0
Message-ID: <CAKTNdwHcCA6taSrwmJ79KYSBREkOZgWrhcnCPG0M6=5XOw7pgQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Register the RPMB bus before adding
 devices to it
To: Bean Huo <beanhuo@iokpp.de>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Heiko Stuebner <heiko@sntech.de>, Avri Altman <avri.altman@sandisk.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bean,

On Wed, Nov 11, 2026 at 10:43=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
>
> Hi Alexey,
>
> Thanks. The code is correct, but this exact failure is already fixed in
> Stanley's series, which has been on the list since September:
> https://lore.kernel.org/all/20260914144910.931518-1-stanleyjhu@google.com
>
> The order there matters. Once ufs_rpmb devices register again, which is w=
hat
> your patch does, two bugs come back: a use-after-free on host unbind, and
> concurrent RPMB requests that get each other's responses. Stanley measure=
d both
> with KASAN. Patches 1/3 and 2/3 fix them, and 3/3 turns registration back=
 on
> last. Taking this patch first would open that window again in mainline an=
d in
> stable.
>
> So I would prefer to drop this one in favour of the series. If you have a=
 board
> where RPMB fails today, a Tested-by on v5 would help, please have a try
> Stanley's patches. thanks

Thanks a lot for pointing this out, I hadn't seen Stanley's series
before, and it indeed covers my case and more. I've sent my tested-by
on Stanley's v6 thread. Let's drop this patch in favor of Stanley's
series.

Best regards,
Alexey
