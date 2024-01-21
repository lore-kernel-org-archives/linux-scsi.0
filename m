Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469DCDF51
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jan 2024 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705866084; cv=none; b=XGaTkNaTDHO2RUb6e+/GkKdEwRhO3D0YLnRCmpJWdN6FHwLNpx9GxsHIZNkR/Ic6W/meDlpQMM+3G7lUCDXPrH5gO4lCuwZi17BpTPF/z4nJCCj7eM3Kf/gGE7gpUzgb0GbaiZomgulNxzCkP6CFb5Lkw/785wh0ncGAi1tdTrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705866084; c=relaxed/simple;
	bh=IKvDUIiLis7Od+kBzkgAchevnQQsci46f6eGcPLjQP4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WPD0XILH/5SPQe0jDbaYRxwtmzuRFl4nkqb7BtsqGdLLaBCNOntS/jdMIVR02EiD4e6NeDZQSEl7Cm+o0X8FrXHbN9U+NZ3AV4WY4GL0eqYqi73sXxphYtWZkj/yOiSRzYg8w31S60/7UT2sg0hfQVYoq99BKqDYtibIkc+PZTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H93eg6Lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H93eg6Lh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC9D1C43394
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jan 2024 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705866083;
	bh=IKvDUIiLis7Od+kBzkgAchevnQQsci46f6eGcPLjQP4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H93eg6LhdD6tKkqDnELahLfXYHvJjCcm4rts3un6oXh9DClCWSqREyZ7xMp//YquG
	 HeuD4RDgef4+FDXB2QDMm/G8eAvmLhcm6boP4Q6Pw+nKD5K7dW206/W6zwP/ni//8m
	 x2/vL8bo011mdLJRseT3WasM2VGk2PT3VAUSCDRal/hwciQg/Ac7R4MlIuOCnKrCab
	 elh40ATuGBynIwOo/WNS3yE6BCPS1vfnxdJkQF8oLukN/o4X6zvlLs1NLfk1FWRb9i
	 MM3kUTeRzRAaxXUNGXgDAkxYq5ulXEg42n6wC95snV8PmhSeTaQXklSr2SG/tnpQh8
	 w1ebvUJGTbKLQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ABE54C53BD2; Sun, 21 Jan 2024 19:41:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 204173] HDDs not detected as generic scsi through AACRAID
Date: Sun, 21 Jan 2024 19:41:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ck+kernelbugzilla@bl4ckb0x.de
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-204173-11613-ZiUcmcVxZm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204173-11613@https.bugzilla.kernel.org/>
References: <bug-204173-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D204173

Conrad Kostecki (ck+kernelbugzilla@bl4ckb0x.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #1 from Conrad Kostecki (ck+kernelbugzilla@bl4ckb0x.de) ---
Closing.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
