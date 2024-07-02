Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D415665B
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719913535; cv=none; b=TQigrTIskKAZ9h5VE1Kklsybgz0Xuz/yOrV2Ijfg+iscU3beeQCzS3KuG5VWbLIEfM3qExgMDjN5GaGsYx4UbgQKgifkFTmHXiTDoZik6ZTX2etJSIaeM1IBAFDnAurpwBhWLqsAWT36dE1E+y0iVrLDkL1a+eWHjjRkc2ksjDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719913535; c=relaxed/simple;
	bh=0ExOWQpUa60sQ6xp+vMwweFYFwiU+IqW2zVD9LIATZI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HvYYVNH1g5Ra9ejDyQDcBaHSYi2rlOuCj7jvKxGo9e9YxvYJ9WV9DnRaIFeb5+qpgFpP2Df38qW1j4/GxEQK95iocXIrJKj1IOqxfOvxcoPRAO1HE74DM7K57ebOzBdWlMvqPDCGY764EAKnuB9BQHZRa62shPZpkq/SUrS/yOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlLBMGbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlLBMGbb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B918C4AF0D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 09:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719913535;
	bh=0ExOWQpUa60sQ6xp+vMwweFYFwiU+IqW2zVD9LIATZI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BlLBMGbb/lMXI4tatuhBHiukKK3GNF3xylzgMkA3dDRQlGHLtcGGacfluPakjfRkH
	 4Si91Y0tm07thbtQHddlGDV0UfykpfQezSNpVDrR/pfZhxli8vcGHNmUAV6Drv0L4p
	 WLx4IM8PVpbmH0UXijCiRBkfzu9s8vbWIKbkbi78zTb3QlCnXzGHKaR4ErmzxYKfAM
	 AFoqEfWcdASUuDf+TrUVHBUuPyZvcQqH1s/dxdblPNjpsVMdbBUrYhF3BmxeE4pInJ
	 ijl91M35lKf6CfhjX5O1jnWQqpPKXgLpY0PLXfYHXBUZ/J5J5HxI2aN7sZDORStFM9
	 oHv5rgImt+PUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6157FC433E5; Tue,  2 Jul 2024 09:45:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date: Tue, 02 Jul 2024 09:45:34 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ranjan.kumar@broadcom.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209177-11613-A6RLNECDzm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

--- Comment #12 from Ranjan Kumar (ranjan.kumar@broadcom.com) ---
Hi Guido,
92XX series cards are not supported.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
