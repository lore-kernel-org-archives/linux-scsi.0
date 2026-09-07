Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F3B344D8B;
	Mon,  7 Sep 2026 03:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750191; cv=none; b=mCYBSwVDL4RUL3+47dUSIL0A4WN/A5YhpQfYWpxFvprbJbLHQaH/1mp28GIMgP1x4rdzLKYPVAu2C8bYb0h9LfZUtXyK4UJl+1K0QP7zg6kD1kK9MNIZLxXPUHtNMgosqhbIBCMZ/n3FGRoP7J7GnfUwIr10AD7MUDXwect9MRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750191; c=relaxed/simple;
	bh=QnpCytgJqGyXlMlHSYS4kwndc1cR0FMmQRrXiWTOr+U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W4sbc2KHz79O/gPq5jr70J/BxmhVRr0DNscl979mEQj2+AKZQVOW9kwIUm7cEez6wK7Dvf9l6k0WNo8nKKrVD2ksADK9DENiydXphWS/sQpWQnD94H4RTOFQYe49tVmOnpVMz7fqrNUrjHpwwbiyzrRHFgHBTLJp0dr3h36oR28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9Gl5tkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9Gl5tkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6D41F00A3D;
	Mon,  7 Sep 2026 03:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750190;
	bh=QnpCytgJqGyXlMlHSYS4kwndc1cR0FMmQRrXiWTOr+U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f9Gl5tkcHHvKuzzUXvzAj+HM5WvgpsCLcJyg/ZnzJ3tjXireIpUgyFlpsQ/OkY74j
	 Wah3pk4ieMh/FK+Og/qRhDtkb4bAKE/DpXxx/7dGnmqcT7IKZXr1rQ4dTQ/SeGMqCl
	 sqcNybslGAVOt/hMNgKw1hBvbUD8h11R2wtrH2ZBgopJNBjzhG82dl1GAU6jT/rDMa
	 XGqzyVjZuGcuNG2KS6P1Onjj43DmkgIDlZvwjx43RSefK0R4ABFPiQ1lFEe7y70/V4
	 +O0NacakTTbMxIbLw3I/zi2EuKnhcRWKi43W8dtkjOMnwfp4GgPvyt20mZTvjc8loz
	 w/FUiadH6O7pg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 25/40] scsi: ps3rom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-26-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:03:09 +0000
Message-Id: <20260907030309.DD6D41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D25

