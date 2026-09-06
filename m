Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8453C279D;
	Sun,  6 Sep 2026 04:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788667604; cv=none; b=p0ryFdYpdv+c2gHLO/aQkcFgEWvYSoUsYVHQS42/KQ1IQ8yEF9Bk+dXsAUBp8tc9G4JKAjrl28CsrUtXdL7DXOX4bmATSC0XF21dsf46PE/AwnqRMLK0v7scR+d5zLrDXjw+0emBpoLVsZh1V7n6E4ntxiTIbeCMjGc9nmPV9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788667604; c=relaxed/simple;
	bh=ypMgPaCo2KvCJI/63Bl1ccCTjJo0ZociWJLim4T8ZCk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ewz4uXhFVV1lTXO01bu86qNqwiVFoMa95ESXYrbf1GIW47f+Cd/QJcYfeqJ/PxKusI/OLcjGYzvpXwaj93o0fyOxdbSbiO788BBPzlLYO5tKnYO9RlBmounTTe6R5v4R480ujj6tgx7CkXr2fdg9YGyrce4eBxhn7ZdCe7QRkKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JajnN31g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JajnN31g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ECD1F00A3A;
	Sun,  6 Sep 2026 04:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788667602;
	bh=ypMgPaCo2KvCJI/63Bl1ccCTjJo0ZociWJLim4T8ZCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JajnN31gOyBdVSslT32fZNqGNwUTkISwWM62/BoPrCVKmDc7FQSlZnToSYBokpUDw
	 HJo4doLebGG/wD44jVCSOgc53WQvC+mH8F2mWxTBonkka0aBqhybk2sr4z3DRrAh2r
	 tiOCaDrz6iYry/pG6Rz+PKfZvWHvF0ERlK8Uv1wguRlDkGiwjUZ9gqbeafFMO6jL/L
	 QGurr3X5yFCI1pryHW4GQteREywCZ+TBivqdKkIFVbXur6tdvdLzTRo7PhNB02yDZR
	 3C8xZpU7Qo7DOdObvtJTPn4KFDFPmX5zdm/GAoOAyDNyY+xi4okK0pbuJS8nFhszpm
	 ktsvEAVWYZIUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ecard: use module_driver() to avoid repeated
 boilerplate code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ethan Nelson-Moore" <enelsonmoore@gmail.com>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-serial@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260906040153.105692-1-enelsonmoore@gmail.com>
References: <20260906040153.105692-1-enelsonmoore@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 06 Sep 2026 04:06:41 +0000
Message-Id: <20260906040642.27ECD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Many Acorn expansion card drivers have module_init and module_exit
> functions that only call ecard_register_driver() and
> ecard_remove_driver(). The module_driver() macro automatically
> generates these functions given the register and unregister functions.
> Switch to it to simplify the code.
>=20
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260906040153.1056=
92-1-enelsonmoore@gmail.com?part=3D1

