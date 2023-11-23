Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9137715491
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYNe4WRP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24A39C43397
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700751518;
	bh=yx4ioalvuXm29cuZDYfRZJ1s745Mte/gj34Mi8ZviGI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pYNe4WRPgD7j0A1x1yNXfFBxDs5ggtdHfTpXXxrnboGe2B38ybNaXTxTaCk2WsxhD
	 CCA4ohGr/ojmbpZsadJc5imBG7F6DnTj3/tl/kNAfZG3VoOBQaNHzzs1nIJKN1kXNL
	 xrBYKVfb1fTPoAWqlxH9OSTspCik+LRFaD1hWIr/axTQYYE+/UvQudeFon/bh9Kys6
	 pisFQW1F4f9WpKjO2ycNfUceVkv2Kx2yiZ3H7vXYXP7Gb8c10EvN9ZdpxSfQGgIOU6
	 myB8jwNRSTEQ+xT4Wm92BL/+0VzIqC9zgifSBLMquwqV/Fl7KO/npiIZvsbgCGDkij
	 gS4AF2L01I3Ag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 12CDAC53BD0; Thu, 23 Nov 2023 14:58:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 23 Nov 2023 14:58:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: joop.boonen@netapp.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-F7ihLuEMyK@https.bugzilla.kernel.org/>
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

--- Comment #37 from Joop Boonen (joop.boonen@netapp.com) ---
Hi Sagar,

Have you also tested this on a multi CPU/Socket server?

I've tested this on a single CPU/Socket server, no problem at all (1x Intel=
(R)
Xeon(R) CPU E5-2603 v4 @ 1.70GHz).

On a Dual Socket/CPU server I get this issue (2x Intel(R) Xeon(R) Silver 42=
10
CPU @ 2.20GHz).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
