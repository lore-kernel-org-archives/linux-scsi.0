Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB213ADC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wyuhl2FN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F14AC433C9
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701281450;
	bh=TDVV0YwLYo//DogMr7p52/2Sa2PgbHSzAJjLQplDSfk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Wyuhl2FNe0Iqw0S/mHKgjGmfcnpCP3kMP0/wn/m3Yf5/q7B39w1I+Lslt2qhQ9Tlk
	 DKVcIsVl6eO/2qRM6vSKU6EKFuVMlrB22brBZXveXDizqqJmnHCmEC1LP8cz99tqeR
	 buMXhFrOAGQHlYMuTK1vNu15ahinQfvQaqsedcodPUp8WGCMGWUOE5oVmvfYVYYO1p
	 AiQdOwby0Z0SBUi2kNKOU0r3q/Nm2W3xG+I3mpb7wA+RKGsMuT+vrjrF3KsW+8P+ei
	 HsZW2ypeKr7Mkki5fRgSXEhB09/cVKAZXe0mtgOEKGpF8BrVHxaIJOT0VQ2QxUopiB
	 C6c0QF2WBpZSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5FFDCC53BCD; Wed, 29 Nov 2023 18:10:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Wed, 29 Nov 2023 18:10:50 +0000
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
Message-ID: <bug-218198-11613-Hrz9hmsxjL@https.bugzilla.kernel.org/>
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

--- Comment #8 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305512
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305512&action=3Dedit
dmesg 6.7-rc3 with device info debug

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
