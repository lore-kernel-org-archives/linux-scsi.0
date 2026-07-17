Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3429D265;
	Fri, 17 Jul 2026 03:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784257241; cv=none; b=NsWqqJLJ35VhpUwY4tEyLK2keHkJykjykF+85pbC0LnwY7ripv+ke8wlOR7hFLY0DxYafsuJHpUEP7kARpUUi8pwAIrS5vwWK7E103JN4w8vrnduLCKCBjNWvjOjoKHwg1uyC9KLfM/Euu/7vKv29st1P99x1WacFMLC4tMaApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784257241; c=relaxed/simple;
	bh=IB/Gu+WjLwWc9paHLSJ/AnT5EEToQL1mbYbs2Ibt5RQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fzbRlgr1RkNbQSaujZMyNUsz78AwI8ODjQB2IV0lwEhgTqXlrRtlWMoZKRKAZta7Yszm0dt7ViPDTqTB0wFCRpNthUwKaUdTviSVVe3h9vvv7NhCOwj0EW+JSt6l9OKxtBsRGGkUkVngzTzt8JeYHRuxc7N0vBCzjnrl+rpRTas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Egb0VRKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Egb0VRKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1571F000E9;
	Fri, 17 Jul 2026 03:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784257223;
	bh=IB/Gu+WjLwWc9paHLSJ/AnT5EEToQL1mbYbs2Ibt5RQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Egb0VRKvoufYVsdXieMzQFZjOO3rmBJkhGU7HdupE9hOrc9JnXZh/tah2ELIbS1CS
	 38spZe62ZanZAn8jAIjV/fu+AmM/bKlaNVCleJhYakc2sRCKyZ0GLHOPHIITAkrdzO
	 +tb7Bzn0tz9OuUubl0OenjvuCkgiOwdCcmgdHkbMy8S2P16kaLlsItrmrumJw+ugIS
	 tgbzXIwc47XBkdJ+L0HykyMImgVZfFu600Druggtic9aAWaoJ1/jtblVkwjjg4VqhR
	 pHH518d7rTrKQDih+TaQP67WtfFZfTNJFNiDiV+Zlc9mJZRj72bH14YawCUGz1iItw
	 SwBcH/xtYcb8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 7/7] scsi: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260716230411.2767394-8-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-8-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 03:00:23 +0000
Message-Id: <20260717030023.8C1571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: David Jeffery <djeffery@redhat.com>
>=20
> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D7

