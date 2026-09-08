Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C744D2ECF;
	Tue,  8 Sep 2026 09:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859989; cv=none; b=Bxp2RkxrbdogloagXz1eVKHt6iHhzCKc0sHaiW3btS030fkXIqlniyzNCp+NJwf9ZmfyX20FIv8A/Dbr2fPXPZqrNlN/S0zKtbQJjD4aB6zkMPaesrFq7fWVaftR1R1fPwyuqWjbFtJ4D9WBopV/ln+2xkONqEptYJb3TX4nHqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859989; c=relaxed/simple;
	bh=RR70AheeUOdpyjFrLJe+SsHHX6U73EjGK9WUrwAomSk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kGRu2pDtSpZmsxXOyYQ4tiyJBdJltjSFSQDCzSgx9j5xC5ra3K/RwhJomnXTNiuXTRZXxxSy9l5mgpD/0UL6ZMCHnLnX8bnCm1H2E0afSlCA6hXHezt0lzDB7Aq/J+8ZKvgxXfEV7tzRCAXbx563v5yDuxykZGAhRrUskTm09gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRK0O41S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRK0O41S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082041F00A3A;
	Tue,  8 Sep 2026 09:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859988;
	bh=RR70AheeUOdpyjFrLJe+SsHHX6U73EjGK9WUrwAomSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mRK0O41SLbQLorypUDJJcPLK/HyavhDilqbCEGrp/y+sPlQUwSHa41Gmvblz3xAyO
	 pNg3oVrqd26SmhC6gM9ZpR2ugoBYPcQdZFNQaQC2RCENw6MEuxTL9gvO/iP3cKj42y
	 GSPpm4wXOBOtBpscd9j9BrVkNGBE/yNrxVnrXv5CMoft+SCrX6pseA5mjZVLvkaYq+
	 i1/FQ105tj5sfKzUOJPvvrfClSxQ7VmaJXbViHXsDfLYjcJ6n3J+V8OBYSAp8DmaOH
	 4IA+qXE1BMTgz6OygbkdjW2POv/I8brAncnIWESJ0QaHYPdb+YY15kLnzLvIa+x/bk
	 Lv+6playUFuJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/40] scsi: ses: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-11-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:33:07 +0000
Message-Id: <20260908093308.082041F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
> field of struct scsi_failure and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D10

