Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21A1405CE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1e5t7xz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E3D9C433AD
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700760370;
	bh=POw8tacIGgaTAROOfsVo97GfAWVPwJraQ2PM6PN+Iuw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H1e5t7xzYc8SPqeVzw5hD1SQQA7DspuxBjUzbjmJPpalXvdpy4+1MwNCnKbZHe/6M
	 3f9KPKLlAVXBy6WOSLgcHE2uw1wtxIHlIil/IYY1iwpk2+ZGlSMjBM0oSozVkVLz/i
	 l/nHab8nuab5YgcpZv6v1M2wnuyvSk69PA1dE4pzGaieCxmgnY4OE25TtYvpDCMmkp
	 izsZpBwLLXRK1GZ2EkIxoicyw6qoDQmt/SmAG7RAzZ1Ev5UhnEGqwMTd9XifUW3OJu
	 lGv+7Ovsr63GDeGKZ42FxY3Jz65pCQhNNHvPoHTx2EH8cGxOiYaceqChHIkDIRhM6h
	 W7UrGYVyn+5RA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0D79EC53BC6; Thu, 23 Nov 2023 17:26:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 23 Nov 2023 17:26:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: leyyyyy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-d6zqxMFAYc@https.bugzilla.kernel.org/>
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

--- Comment #38 from Maxim (leyyyyy@gmail.com) ---
(In reply to Joop Boonen from comment #37)
> Hi Sagar,
>=20
> Have you also tested this on a multi CPU/Socket server?
>=20
> I've tested this on a single CPU/Socket server, no problem at all (1x
> Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz).
>=20
> On a Dual Socket/CPU server I get this issue (2x Intel(R) Xeon(R) Silver
> 4210 CPU @ 2.20GHz).

As I understand him they tested 8-series controllers. But we all reported a=
bout
7-series (71605Z, 71605, 71685).

I do not know if it happens on 8-series, unfortunately I do not have enough
HDDs for now to check with 8805.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
