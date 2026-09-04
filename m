Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7387352C52;
	Fri,  4 Sep 2026 01:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484395; cv=none; b=JGLYmjweUgVUivK6RHF0V7ANNONpnAYCUAYIOBdhbZUq6XwlLUBkF2+N+107j1fm+0ttfVK44qOR5/HoGDCR89jY9POi41Tac18qQLyjjlWOViccGtcKZgiB1GshfwOqaAIQ7IAYK2pzgpJ/8knuidsS5rAdV4YO1euSDXCPXQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484395; c=relaxed/simple;
	bh=Sep5+1EEkVSLXvA257B+zVaBDM7c/m+hjMlbXedV53A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l+ZL8apCgsgIPgGZ4N/BAK6htwEHqJeLpGCBBpAHWi6x2+1x/wOhdkvl40ERPDJ/plh/QLyILUxsPNEMnf/R7+3xc5uI4cjaJEq9rlsgVsxOUNG5kgEDKerldk3KxIp397o3HC1lhJOpC36u9TtMPpt4V5u3vQFfLo0nYyOD+hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBeD8WvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBeD8WvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12AB1F000E9;
	Fri,  4 Sep 2026 01:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788484394;
	bh=Sep5+1EEkVSLXvA257B+zVaBDM7c/m+hjMlbXedV53A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hBeD8WvCA9JrbguefImR82a7wczywFDDf6xqk2KC/XO6FN5gHpuC+sG+KqCRoAFCz
	 e5IDQ8VJD25bXJKJkyRh3ZZIkWcnxFC+aZ5LHhCH/vOSFULoJfImNBLVafvmTgJdAd
	 coRNp/exzt7F4eOzm8BJBZMw9WoMD8no5Q8xO6G00MZSm85UVOE/cXBtG+Shfj2+BJ
	 jlQ2T06nCqDBlukYdF0lFnl4jv4NtoccZYXqPQVVyR5A5t0k7jbxs/Kc5RRRKq8BBd
	 tlRn+4XfM1E84qWVJoQOGuP5PYNxbjJT+Pt/DelT7+MCLBgKq1Ns7ye5g3HioW2G8Z
	 /5UiuAY+drd9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260904002644.157668-14-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:13:13 +0000
Message-Id: <20260904011313.F12AB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the HP sw device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and struct scsi_failure and replace all
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
68-1-dlemoal@kernel.org?part=3D13

