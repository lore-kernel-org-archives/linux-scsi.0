Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E863149DE7
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2024 10:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715594955; cv=none; b=S9db+9NJBorCoqahDtwIzGv0R4BLWiT3qm5gPTZhgDuO7plSn6c2+d+cJuuX/B4v1MDaCXLpSZiGOC4pRvufQg63gonscAY7+N5oosHDL3JnLh8lq7C6Chou86s2I9i065UpL06PQ8si4laBl/o1unWB5IXDcmCz+60B7bLkp9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715594955; c=relaxed/simple;
	bh=43mAQiWJngvOxcj+Y+F5a4faleBHVTDgMA2PakA1lvk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wp+ZBYQEpnfwQHsGcjCiDH1CgwvPCo3CVA95J3vuTMjFXp21MDesCYp++SrpJTaNEvO9YR/O6wPkCDuFPLzD5bmvmlS3N0IaVc2yWEkpeHz18yjiYh11qOv1drx8oedZaxItky7oPk0uJkIISsgmHvu/uA32q5fy0+CcUjqILKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhvST+9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhvST+9J"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4430BC32781
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2024 10:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715594955;
	bh=43mAQiWJngvOxcj+Y+F5a4faleBHVTDgMA2PakA1lvk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bhvST+9Jpk1xfoOWfv0ubBwX5SNxbMBT8OPziS8d2j30akR5jyWIOVFNifek8ygUX
	 CRRW9Ug3UQJBOAI/b8qj+oIUN+uj+HrgZB6lIu1/DtIX6kbZZwTBdoZtPmXcJBYpPR
	 DnH4CNHLmwoU7QTEaGOZbKCix/aFyN44+RFsgVJkrFfiv4zfggAkLWsKee7d7FRTc/
	 FTG4bhu2H8eZ+sn8HXO4NyOLO8M0G55lel8LzOlcUrhv2nNdF3LzwQq/Nb80ReX3W3
	 WEH6ZASO4tG+3+QfswWrbo0F8BIzOfgC7PunlVmfso+iqwQ+tKs1F3U4UcmrDfzpCf
	 sbcx5IM9WEgeg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 38419C53B7E; Mon, 13 May 2024 10:09:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Mon, 13 May 2024 10:09:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vaanshsharmaa@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-WQMwvrvcOe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198923-11613@https.bugzilla.kernel.org/>
References: <bug-198923-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D198923

Vansh Sharma (vaanshsharmaa@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vaanshsharmaa@gmail.com

--- Comment #15 from Vansh Sharma (vaanshsharmaa@gmail.com) ---
Do you adore the self-sufficient=20
https://www.girlsdelhi.in/south-delhi-call-girls/ in your life? If so, you
ought to stop by our South Delhi escort agency to see our independent escor=
ts.
At our facility, we have attractive and seductive independent South Delhi
escorts who are prepared to assist you in any circumstance.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
