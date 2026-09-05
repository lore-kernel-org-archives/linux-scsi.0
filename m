Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CCA33A9FE;
	Sat,  5 Sep 2026 03:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579068; cv=none; b=TvbSoPUjcqLEVFJt5P6cj7jwN4k4SUTnAD6NcJKrkrn+6LfoOVXidS1WiGP4IQxlDGVOkc2yeMDNtVdw8Oj+Tf39hbPGWlH9FcIl2c6S+zYhZG/mrx8ZsC2apQCTKwNcRHeL+a45K1L3B9YsmlMnjqb2vnLQhYKedQnYsR6ddIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579068; c=relaxed/simple;
	bh=qAAdDMShO2PcCvRxS+RbIrg37qywIuao6BVPjSi0j84=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=br2SHUFkcEZiLqDvm9XyIERiZ6kY5FL3xt1iZ3KpdOmPsjN02DmDVodK8juCP6NDr9PYx8ELpmixhdHB6MrFzJgU29QNN/K+yFiJ3a+5uibCs0rqhZ+tQ6moDis5Z1kUgc1ZodOG2unREmFS4s+Jzh5W+hXCkHgaEhkwQGTp8fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoOVczu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoOVczu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D001F00A3E;
	Sat,  5 Sep 2026 03:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579067;
	bh=qAAdDMShO2PcCvRxS+RbIrg37qywIuao6BVPjSi0j84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QoOVczu4GIBjC6a4rKS9Z5tTG1DJ+L8JlA72QNzlR+p5VcQP2HpP12bIb/B6iFG5t
	 mCu/l54uotWVEXGZVxrwVXMcF3AW3lykdgygpQOQeSjUPRP5Nv6AtdMBZfVz46Fvom
	 zK1ReL4jmcUrfMQWesRJSC8uuCBoUU/CcJGJO4yEW9ruaW5ObZEDZ0WkS7mo7MkAsj
	 dDpQ1DVPM50uqbbL5VoiPqWJpmIaEQvmokeAm/7dwB46+vZvNmmz+YsDp7hX9q7oZb
	 X4AnooCoDYeiPTep3kpFlRhMZJNLufx8Ya/4+/VD6vTpthGgNZf6VjwJIl3mnZiCnD
	 IuC5H3ziC7ozA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/40] scsi: st: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-13-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:31:06 +0000
Message-Id: <20260905033106.D3D001F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI tape driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D12

