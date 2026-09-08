Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002793451CD;
	Tue,  8 Sep 2026 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862083; cv=none; b=jnxoE9eNkbwO691ubL9oua7oM/r3jDqBBajk2L8nTcG8Xcg20aDxT1jgYc0rj3RdStySOU4T6oFzT7XUbTAcFKBj2sVuiY1FKgNQTMmDGhZ3ZegX0dAJg32HmX4R8/OVO3XaGZNTVYuxUo2nlfypICq0XxGfucbNrnj4gwqdvtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862083; c=relaxed/simple;
	bh=8ZFKbMW8Xb+PKv1KtbNDl6oDUbYA3oXarGU9SqAbFmM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xgv0I93xATWgsoT6sdPRGNlpxvXXVtHEuC2c7BZHFs2p0rcrb2HOz2+uA5FnGPFPQ3++sEDY4fEyLTLq0+8Wru2zQ8B2ebp1bwCLeR2xLl7bXucxkXbKhXgiyWscIKn8TsnzTVtMUhTcX2luz/eY6b2opw2G9IwX+67aICNLFlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOstRGkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOstRGkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AA21F00A3A;
	Tue,  8 Sep 2026 10:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862081;
	bh=8ZFKbMW8Xb+PKv1KtbNDl6oDUbYA3oXarGU9SqAbFmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FOstRGkChHwfoZpsI4mDUuHTX3MZ+WyiZsZsHdaNE0s5dMCvuBPwAP90F1/DZkGBI
	 m68sCWUKT9lnPpj4IyBm2Mpp0sd9fi0ZUaIvC6GnAkN2Z/kzqt+YIJZm7lFs10Sj1E
	 Wlw24mlLX5ezB8d6QkucaRjzV55ydikMeVLNxOMdu4iDMySbVJjqW1S27Tfx0mms/o
	 kLuN7Wv8TyQ10Qko1tsDVQ1UI1qJPExZ/fPQxfysMvEVaQCYM8hg7MMKFBQN/AnI3l
	 vTl1nMhHdZuW7F7zqhhmT69fD1ncGTGZD23XGVksH4gYuEOOAHKRagnDIow9H7KqpD
	 Bkapcta3xPHWA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 29/40] scsi: libiscsi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260908090308.1085097-30-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:08:00 +0000
Message-Id: <20260908100801.09AA21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor libiscsi to use scsi_set_sense() and replace all hard-coded
> additional sense codes and additional sense code qualifiers with the enum
> values defined in include/scsi/scsi_sense.h. This helps with code clarity
> as the sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D29

