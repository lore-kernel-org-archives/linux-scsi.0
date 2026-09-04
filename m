Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B49336EAAE;
	Fri,  4 Sep 2026 02:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487702; cv=none; b=XDTlBjvT/PWKi0SoFOTPQqUztRWA8jbQBl06a8t+R4vzXLqTkeAb9FYJjgX1YHRexjBtBi/MfBZ4aGyW/Vs0Ta4z6rZZb+CiQfv67TllruCMNYH95RYqbET7gTicQ/mnTeraN0KsZr2hAhC99DD4DM63eOH14nkNl2bh5HXrL/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487702; c=relaxed/simple;
	bh=N4p+hEvC0xqigkLOU/9zQEFln3QD8pYenbUyGV9tTLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EDKPUgX0ZkkmRKhatsEqpG1uEX57WTa5K0XR2uTgBMxhCMdUR33/q3Q1S9X/WlV+k5TN461YXTToC/YU/mrU+N8q7oI95+dMSIFFRl1u8yYKWaAadIO7OCyoBOEwbak/9EhoehuJob4m60px53MPIqiAURZqTSrCnFt94Z5RnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLLmlKm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLLmlKm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4FF1F000E9;
	Fri,  4 Sep 2026 02:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487700;
	bh=N4p+hEvC0xqigkLOU/9zQEFln3QD8pYenbUyGV9tTLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OLLmlKm1kqDivIpb/m/FYTqaQTHmgdk1NnDz//YQrZGWywSadzgv0Y73rnORgxNs6
	 fcVXrMhlrvvEaK0OdMh8ncE2ic0uS6I6kywddoyCzPCk2rqx7JRrPczK6qrNROgmMP
	 kuT+ywHrnQyAZmmxgXpi6T8SETqYAUy7mkn2vqa2O+lGomETkh3/9uMkumAGc/z6Kf
	 C+CDcSxo4irORJ2Zv4YGIhVqao+sshl2QoXvT38mgy2trOmaufhrMGAX7yFUSoOjjt
	 6ScYuouLcsyIkFihgWizpH/yMsvuBItsdAAJZhwRr/djCAXUV08SM6enBZjVTPxLD/
	 5bTuGS0tD9NWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/40] scsi: stex: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260904002644.157668-28-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:08:19 +0000
Message-Id: <20260904020820.5F4FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the stex driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D27

