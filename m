Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB6819BDE
	for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 22:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1c/YF0C"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5474BC43395
	for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 22:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700691539;
	bh=MvFenV857bSlVnWK5VPaRPyUwaWF1FpHwY7gkuDHfHk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=F1c/YF0Cem8eBs1MOIT63aPpL+XEyyfZ7vZ+t6YD+PMySmNXWgEXKoh5h0ZmnHWgJ
	 Yk6uEV2VVgz/B/qWSWicgFzED8yMZ+2yeaP4eUT1gfHDR1dfmpnNQEsVJi9m28KKoy
	 kvgNkvLd0m7ksQtbR2ah4RHix9JzT9GdSKKeaOqivBSbYbNDgnOS48hZScoreYtD2D
	 8JnElbkcezOPkZKd8MWQkHIPwuBzktQHWH8uAxxWNgxk7TRugJ5axeSDrX0X5qBRfp
	 8YTE9YSf+ihFzBCoFvO1didShb0ttugzZ8H355JjbTmf9xdMmgN7uZRxIjnM/+c5wA
	 taJCcHZvrEl6Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4640AC53BCD; Wed, 22 Nov 2023 22:18:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Wed, 22 Nov 2023 22:18:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: randyg503@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-tJEFM3Xts3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Randy (randyg503@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |randyg503@gmail.com

--- Comment #34 from Randy (randyg503@gmail.com) ---
Probably of little help, I will share that I can ping-pong the reported
behavior by switching between two Flatcar Container Linux releases: alpha
3717.0.0 (kernel 6.1.50) where I DON'T experience the reported behavior and
alpha 3732.0.0 (kernel 6.1.54) where I DO experience the reported behavior.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
