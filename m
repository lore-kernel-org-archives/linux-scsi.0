Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A26E5685
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV92P8DR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E6A1C433C7
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701155297;
	bh=F5ZCR/msXyi7wcob0+oiWW8z1AIK7m/dkHhJn/Sjm/k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WV92P8DRRunBvbs8obC17YWD0pfzZNDoGU9q8HBd4gSqXdAUahHv6nYBBe26lE6Ci
	 bjs9zRJu2fRFypyevXt7VI0c+FeO2Z1AJrj2aeZFLqwZxsgt65uDDT9Y1xxTOhce68
	 iD7JhfJJDAiQLufjvB3th3Ss5M6YGA7duuSCU+XjYTAiBftKgflQj0gSoh9uyQiiK3
	 kKiu2Nxh9AvkG87Aiy5PtvkVms1MEZ0YtD/VqBiOwPuX+mB/sDI1VQgeHu5wPJ//r0
	 WwranGcJO8A4M07IvrxFhGU3s5Ez03zMPSKHZfXn9krZat3U7ZAfohQ0EcR53NeTcW
	 VPyApO7azViaA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7E329C53BD0; Tue, 28 Nov 2023 07:08:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Tue, 28 Nov 2023 07:08:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dmummenschanz@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cf_kernel_version cf_regression
Message-ID: <bug-218198-11613-2hGYDa2SZN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218198-11613@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218198

Dieter Mummenschanz (dmummenschanz@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Bisected commit-id|                            |d035e4eb38b3ea5ae9ead342f88
                   |                            |8fd3c394b0fe0
     Kernel Version|                            |6.7-rc1
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
