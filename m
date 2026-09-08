Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7051AC44D;
	Tue,  8 Sep 2026 09:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859626; cv=none; b=nVhM9lMhBpOD0kJPkBa45JX1QzPT+ywhB//8mfJBCVwWRq86jUsNlaULxUAMxZaD1usPCtVDAVMUAuiqnKkAzYbAEcJPxfymjXcmFsUDibXchQ53KyyWM1Gd5ONLFabY4yctjImi9Nm+z3Fth7HESgriF5lfeWZwxzD5coTMgYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859626; c=relaxed/simple;
	bh=JBMYId2cxNRtQhqsUyzxS6H34hjUfu0BQahvxG95id0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PsUGRRnzPjsMLIPLQYbgr+dWI6yQx82FVzbULUvWUnSh6kiZKXXOtHMMPaPttQYa6KeDQK+UBv1+tkEFgyGTrzihkXE+cDdEelIO3AjY82yZIN2ZFTBhK0+x+uiNz6/4pQOI16bthSWICFjuywHJt6tKNZtDfD2HcixcL9z4sAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YRlhb8o8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRlhb8o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1C21F00A3A;
	Tue,  8 Sep 2026 09:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859624;
	bh=JBMYId2cxNRtQhqsUyzxS6H34hjUfu0BQahvxG95id0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YRlhb8o8+UNW2lX3h8zHRG7jI8RoTfnA/VRkiugHTP6CRBtf9GvzaHRDkFkdZAOjx
	 9w6/CmIvumx7Q74E1q6QsCQaymf8DCDAvpcPlewXNDjlWbIQntjIJO+4h1KxhLC84b
	 8PQGw6+kLPMNBp7CMwLMGm9j6YUKse+AwtBAqJr9ps0/rDPTSMzxm8FM/id/j9N67v
	 NdE1naYTfEU0HVaLgK69sSj0nDt+CjlOho2OosE96jqgEvWQUvG1KTQQL2MqnYoYEY
	 rNnoWfEErXBFXhyU5I0huz5+0fwQZCltSFa1UBHotx/YBg1/4DE5EGiZ1reZ56r35H
	 GNax8ywPVMtDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/40] scsi: sr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260908090308.1085097-10-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:27:03 +0000
Message-Id: <20260908092704.0A1C21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D9

