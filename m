Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21D34E13E1;
	Tue,  8 Sep 2026 10:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863258; cv=none; b=fr5j8/QKLK42jAE0T0inNU9mfuIyb5c8iQiidSSJNI40H4pOid2RhGIyBp0bLC+UK9fIgyXXu6DIfEe0AYVARGxHzMyAVGQUYyMLK6bKhlHA+89GL3czHCZsqEwXmYsjuUotbeLcmIwRO4FjHKkqFJPKSyf4YWP2AmXZp3TSXjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863258; c=relaxed/simple;
	bh=msJ57HCJxHeQHQTZhCkkvpG42GWJ1fsH9gfkrBw1etU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rbHzjqqzWpvlqT3RbqjgoBDsb/34tErxbeD6TVT2rV7jBohdL8Juxi7Jlq2SZfvTcjqGP6BWI1CaZILfr84kJF0EiPn2z+MDt+3v2TxFzVyEADovIGBScFVZ0P7KnPexxOus3aJMyOmbBVNO/6grxhat6maVQ0v/FCKaY9aqv78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPnZGnTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPnZGnTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B9E1F00A3A;
	Tue,  8 Sep 2026 10:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863257;
	bh=msJ57HCJxHeQHQTZhCkkvpG42GWJ1fsH9gfkrBw1etU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GPnZGnTPCPL/GLfMQMa2GEPLGPmegT8LJKM6Vkf0ckk2Ry9DZAZ/Vv+r4d6r8WGxO
	 6QhKa2pJCA0rpOvEyH3oyJgS4vqettw9LUZJTX6MdjdEugiHDCIWv833VWhjpuZ7Bh
	 NU3RmNxcxgfSzg809YsA0D54OTZ8xRT1pUQKUfpCJqok9+WWFk+/3DisqAdomp0zF1
	 nOuRKRZ7kuBnzaZv+4lwbfHWO7Dklx+QI89xNIP3XvVfunQ+rf840tCQBuoUYp4qTr
	 ANYUa5iuPGk0koBQAgjH0gbQQAFQDpn019BIq7sDx5R3ufpyyySpmNC+kt22uOc5ID
	 Z/DWS30xKVxuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 35/40] usb: storage: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260908090308.1085097-36-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:27:36 +0000
Message-Id: <20260908102736.C1B9E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the USB mass storage driver to replace all hard-coded additional
> sense codes and additional sense code qualifiers with the enum values
> defined in include/scsi/scsi_sense.h. This helps with code clarity as the
> sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D35

