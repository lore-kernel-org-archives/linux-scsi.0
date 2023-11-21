Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B02581
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcp+bi0d"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B83DC433CD
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700573076;
	bh=wTP1P64kur+PXhY2Px7R0GRC0XRQ1r0rE4OF/ErQKHs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dcp+bi0dYbjDRCOBitCXHA3XzjWgif30zz3W6MKuSWsPqtmk6JncreJsCOJjF93T3
	 C0rCauGk7uDLv8Y7jkyYjsFAuBN7iFtbaqf+jwCrG9Yg0evu+YZ+93MkuaMziWsTh6
	 TXaLdR9drSse78gHRTgoTLvDfLfo4TynSvmpRZkR7a1DE3L2m1detluQv9SmqYO/3r
	 22qQutnRQ9ye6GNnsd9hJDRaPrjDvbP56gFHOMSEiPomNlvpk1BZBEECA0Z7nHh/2y
	 Ga1CgSz0dFNEuN5n4CEMH1SLT2qTD9V4HZUYUgKWUlzqrJ7bEoBq+Hx8DvEme7z0/j
	 DzmCcXA4ypa+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F06C9C53BC6; Tue, 21 Nov 2023 13:24:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 21 Nov 2023 13:24:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: James.Bottomley@HansenPartnership.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-NBozZwI3Bt@https.bugzilla.kernel.org/>
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

--- Comment #30 from James.Bottomley@HansenPartnership.com ---
On Tue, 2023-11-21 at 09:54 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217599
>=20
> --- Comment #29 from The Linux kernel's regression tracker (Thorsten
> Leemhuis) (regressions@leemhuis.info) ---
> TWIMC, I raised the issue once more in a mail to the people that
> should handle this:
>
> https://lore.kernel.org/regressions/c6ff53dc-a001-48ee-8559-b69be8e4db81@=
leemhuis.info/T/#u

Switching to email since the bugzilla seems to have stalled.  The
kernel lists will discard text/html email, so if you have email
problems, you can reply by using bugzilla.

Firstly, can as many reporters as possible check to see if reverting
this commit:

https://github.com/torvalds/linux/commit/9dc704dcc09eae7d21b5da0615eb2ed792=
78f63e

Fixes your problem with an upstream kernel?

Secondly, John Garry asked if you could provide:

> Is there a full kernel log for this hanging system?
>=20
> I can only see snippets in the ticket.
>=20
> And what does /sys/class/scsi_host/host*/nr_hw_queues show?

Regards,

James

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
