Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E472E1F0E;
	Fri, 17 Jul 2026 02:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256722; cv=none; b=Yai7Ht1BwsjM4SdyH+/Wq49rzcB2CDhnJuZe/usqALJ7ScVeCwZvqqTFk4apo04TclrWLvGI/a64YvuPvv5yIQd/LwrJH50WcgOH4kvNCCQInL5xXSNuy2ZfigYj66rOV5vUy/G5/ehDlTiUYJbmNC1pDRSy6TB1QA3j1EgpgtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256722; c=relaxed/simple;
	bh=r5pbo0zGFg+MzUa+Pb8WnOAj9Qu7kD9ZysmFKhdavNM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iI7umfulmEFKKCkhliwNj/JzZ3uRHidwc33WI75oRHs1dGO8Ki9aCFQz+Y1+CMJJiuvFHaNPimDdva1H8FIOwa4ovfXJs0p4pYqmFxfhb3hx4yWENhIPSWxLjm7dNnNzFChopja+oH6KnR8kG2NFmzZWaC0MWXxDratbR2D9f2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Of3H/Do5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Of3H/Do5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1B21F000E9;
	Fri, 17 Jul 2026 02:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784256720;
	bh=r5pbo0zGFg+MzUa+Pb8WnOAj9Qu7kD9ZysmFKhdavNM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Of3H/Do5Yajd4NOIk0SDUVMc0n1Npx9s7ADKehhyD8NR91bBiosGxoU6AdXpOc2TT
	 3MqtBKKkbR8MQ6IULnQCKCdyqNCkVuNVvTmEMJTkO1LKY/h5KegJifPXBwZfwRlPAw
	 QTE6h1njZiPbGdzIPu/2CSKhR9AENxVpVaGoNJxvv8Bnjbb1o+x4fOQqijS3tuX6Lk
	 IvUB8U1k/Y9Ok1gLJfsLDutOXUErdS4UyexaZ6763AyVBrnMVn8zV81SuUzkntoUun
	 +ezc23XAbB8UmGD8A6bQF2yYchPppykKGyrIcX/vPacxVzklCmXQrU7TTkTWRr6SX2
	 GuOvpEuwoskSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 5/7] driver core: async device shutdown
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260716230411.2767394-6-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-6-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 02:51:59 +0000
Message-Id: <20260717025200.7F1B21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: David Jeffery <djeffery@redhat.com>
>=20
> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for the=
ir
> dependencies to shutdown before executing their shutdown routine.
>=20
> Sync shutdown devices are shut down one at a time and will only wait for =
an
> async shutdown device if the async device is a dependency.
>=20
> Enabled by default, async shutdown can be explicitly enabled or disabled
> by using the kernel parameter "core.async_shutdown=3D<bool>"
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D5

