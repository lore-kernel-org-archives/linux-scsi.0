Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7DA14267
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwvz9yp5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFE23C433D9
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702894975;
	bh=YRpI3oGYYOew3vbp1tkSKgCHYoWhnHGQTQRFRf91mqE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qwvz9yp5nK5mjrPiQibfgtO5MPbV8gk+q0x+yICXWjwJ0nw4CBhl1OfsILlk0U3QV
	 65WTJP9hfE+ws7yAsofbOlmbR6UFX8xpNASGqVA9hENd10UMEi56SfRqbR5zUh8yjE
	 Ik941ngodhJcrNZqwnKnLg7MXFzpgriD7VqesrlvsKklvC7cFzuEAlJoIutK5qbKeZ
	 6IzVHNYQ29mLZtBB3s30nnAtSUQTSiDcE3Pbr2+1T8jCFoGsFSA/OAgMl3YZPlkMF1
	 fL/EVTbvhmC37dHHlObpmYEDzZKN2uWpYRXtvFM05OR5cNW8JZql6AG3Rhvb6SZWLP
	 hMeujm0bCWedQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9E602C53BD1; Mon, 18 Dec 2023 10:22:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:22:55 +0000
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
Message-ID: <bug-218198-11613-HvWwKm15M8@https.bugzilla.kernel.org/>
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

--- Comment #24 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305630
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305630&action=3Dedit
kernel config 6.7-rc

kernel config 6.7-rc

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
