Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793961852;
	b=BAJaRTveNpFYqRe34cu/bf3fjdhWBu3Ci4Mbjhyo6BLrHTqagOzvccLY1/ICpp6Ia2+Z
	 ZP0OxERmw/TTFXpObZHYJjwZSJwvXeL30AcuUUNmapO0+cu0yc9qiQrXFm9kfqRCMHEP9
	 6b+Z2tfSTzkRirM4BWlwUk5dMa+RJ6jsirvlurpCJtowKxmzyDxZ2hqliqpsr3iJZ7TwK
	 n08z6qQWfW44znoPoA/lOLF4zZZSRG8nC3/B+UVvjU1akdhSYjhA8bAxMnRwH7MQgtxDq
	 X8bZbq8/e+miquQsRzGw2i7ylJk7noieW2X4nv5yInQNaM46Lvt9N+l2AS888Q6I6Rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961852;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=oTiRhwOL8L0AMD8du/ogqEbeV38LU+5l1kVkLLOBgZw=;
	b=eEJxv3R0hkqJLyQu0eLn8S24zKIyKulfiwhsTGdrk//MQFeh8dYsihTIuMhjYP7YUTlY
	 DQXk2KGE0VjL0LMPueNeVCDR8j81UjMwnH6/sYRVxtaFJvvWR+9qBRMr7N+j+9wcRRWS/
	 QD26JNL7BXu5IXaohkRH5Sc+OUfEwAXhNyTXQvDf1XrFQOo+sql9lO1HDy57Rx+YcaZhh
	 6+orNEU7QDy2FFClAvnGdarOoQW2NreIRGe8KeYDKesL61n5FPr6soNYQiRBmTcm4g1cU
	 w7pt/pO5QYNHVXpl1VVCpqmujCcCTTvMQAIvZCYmAWqqzmXJnHpYs+kWu3DzLAi9Y3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=tdwUNit7;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=TcUF6uEL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6936606D809;
	Fri,  6 Nov 2026 10:44:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6936606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=tdwUNit7;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=TcUF6uEL
ARC-Seal: i=1; a=rsa-sha256; t=1793961823; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=VGupW5rfD4aEuBhuUODjXq1StMPbzSHwRvzDWgNtWFPKwa3sKZ4mWdvNL4+kfSUO2Z
    ev2DSasbruGmEZwFkvpSgd77Dzf/FU2SGQeKRC3/Dlh1FpuBkdi6MxnHuCSytVnznO52
    Fn7/JlMi9LT0wPeaNMxps1ltwDLOh7ceKBNzx4GIT8O77O6ztzEwDUoJbTH9Pr/L2TMA
    78nrsDsBHDZeHqkGhB9yhz3OCNafMz0BqEho6LhRT1xnePkwlsuPlvcKGAWYJRo3h1+r
    Iv4zAoIZcJTRkemIcjE2X2ERgtGFV5KuGcB6ljBHm2n9byvyitti90t76Tj+9Y7NtF3x
    kh5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1793961823;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oTiRhwOL8L0AMD8du/ogqEbeV38LU+5l1kVkLLOBgZw=;
    b=eZXFqVupWR1Ji7qxTBGIV1RQtxqBRbx1DZhQQpBWnB/Z3PsdLcYw3IsnmJwfKK3BoQ
    f/HL++D0s8AQy4HFfKtjIbqNK759CCG0xwXdLD/ArDjNz5VawkOsodlRP55oWsjia4+X
    NB8KdmRypc70gnVJ8wOXGFJ4AZ2uD+GcGSZfWUdqox4KUAZv0Sr19gVqJDk1eED+Vc8D
    BWBYKPu2/JPTOSKzgUqmf9hfE/+Ch2kaKPFIWcq74HBrTgaTEl8fYKfMP5zHpST5qMYQ
    xJvLuMf4VuclY1lxD+39EsZzxMyuZJrX8wKVKIk4zT2l8nPHJTIKbc6sBDHMD940PCE5
    iZ6g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1793961823;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oTiRhwOL8L0AMD8du/ogqEbeV38LU+5l1kVkLLOBgZw=;
    b=tdwUNit7Opu3ks6K8mEhlULdqWlqZwPVIuI7b5AJ43z1pXfMQwlohT6M9kDn12TNnD
    kq/uUboPg0bdJobTJTw9nSfxuU0V3A9by9vJBGFJ7jl7df+2qq4Oa4JZrffKYQY0+IVn
    PWzcOeVkIzDWCb+5JVlPdHL0eWIkjoQUJK8vUAckD2qDJgu+CeDgAP61zLCYcOUH2kKE
    2UnCZFBXXbLLbW0tMQu8zg0t33x7Q/sSX0qgtL+nUL8BLxN7zjRfwsFcTbo5ufXDFHK2
    gr0PrbipvTV+puy/86TwtsJTRDSD9k7UduDR+n6QZqz+MDX8ySk+wJcMILHrOKLn0Rxg
    bpvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1793961823;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oTiRhwOL8L0AMD8du/ogqEbeV38LU+5l1kVkLLOBgZw=;
    b=TcUF6uELeJ0vvRLwRnLnk+hkEyomP0511RJ+SILJiXZCJEa57IGTibQZsP1JHnPH5e
    vNhI1dQI0eJ4E0vgJNDg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+r7SHz3oVvc+BBXFWWqpPHifFkxRYsbc="
Received: from p200300c5872329ba1bf1a4d6a312338e.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2A6AhgKnj
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 6 Nov 2026 11:43:42 +0100 (CET)
Message-ID: <2e5f4086c248fddbd541d97dfe85ce594c0360c4.camel@iokpp.de>
Subject: Re: [PATCH v7 2/2] scsi: ufs: mcq: poll OCS after sq cleanup for
 device management commands
From: Bean Huo <beanhuo@iokpp.de>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com, 
	hy50.seo@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
Date: Fri, 06 Nov 2026 11:43:42 +0100
In-Reply-To: <a1af44cd90dca0dd8a9a06d09a254a4e7e0861b2.1793938245.git.kwmad.kim@samsung.com>
References: <cover.1793938245.git.kwmad.kim@samsung.com>
	 <CGME20261106041303epcas2p19b0c317d409503c833ae125ba91fe053@epcas2p1.samsung.com>
	 <a1af44cd90dca0dd8a9a06d09a254a4e7e0861b2.1793938245.git.kwmad.kim@samsung.com>
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

On Fri, 2026-11-06 at 13:12 +0900, Kiwoong Kim wrote:
> Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ ab=
ort")
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
