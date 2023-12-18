Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7538D14F67
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IP+HZ53p"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 469CFC433C9
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702894927;
	bh=5OEuWWxFV9gmhLImKP+Sg/8LFMXjcslIdW5zMLiPrww=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IP+HZ53pvgRajWhVkO+BX3FL16JyDPXQr2vUbm4BXsA1zNKBN7G7MDrUAaTAUr9SN
	 1PFKzQ0LdPjT98xCRqTAcFjNHVhgmuqnyvTpNYjzwrbvq8SrIpR6+25lsZh39avXXw
	 jxYA61xDhjZp8hw0jhNvY39/J0oFDwqRLpceGyck4XgLlT+P6MhncC1v8h5ImWcoK4
	 28RodPf1M6gvNpq0JiasL+OymmLHX33eC1/Fj+C+nlrlKElR/Q346+cEEBPH1BL/q8
	 jbJRwcgl4DNO9wmNepf+FszXPueawDax4oN2vRTsnHLMMhrjv+Lze/cSQR0AZDQt+P
	 4yAbfZCpkCGnQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 36D15C53BD1; Mon, 18 Dec 2023 10:22:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:22:06 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218198-11613-ociOz1RlQ2@https.bugzilla.kernel.org/>
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

--- Comment #23 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305629
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305629&action=3Dedit
dmesg with pc8 transition

dmesg with pc8 transition

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
