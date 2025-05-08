Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C711E0E00
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2025 06:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746684223; cv=none; b=qDaOTwFhRTHMT1uEWHS4miAkhDgqwXzM56jiErpitTCVVuIDB3OhyRuHBYbOol+ylQOCZOXq+JIG2dqsVvaLDsrt4rIBdrA8mZgQNMLWzgw50xxm+DFg+nHrZBUKWLQOeohzCBaLXhVrnx15vC/+7CRHhGXM1yS1Qs50Al5wm5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746684223; c=relaxed/simple;
	bh=zR+NOhXGGib5bVR9mfpujnxn85pdSCKsCClSsnaOD9I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NblubYYKZmaaBXA7WLTC0IezG/cPfnnvhIm+VhXDeswAl6fombqCsMjDZcndj0Y9PzFhQyRcBn1zCb0nT174lqJXWhgcYauCf/jgv9x1MbnFtNbQLDFKZKhUQf7hnynWPa4R4cwXFtQH3+KbuHQ78TGEXDoLH7euoBkQCOYfQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4Qrc/1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4Qrc/1A"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF9DBC4CEF6
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2025 06:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746684222;
	bh=zR+NOhXGGib5bVR9mfpujnxn85pdSCKsCClSsnaOD9I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b4Qrc/1AvRUqzG0hsWGC8pVBZfVWLIhRU/yc2mtorigVgyI1MTW05Sm2FMip/RhiY
	 YXI5AepBNEMnjjy1QMqkbzhiY9kN++V58PYwAEfy4CFA1TI6dcELfkJiBWYdQB2ZVK
	 ahzVXOzpYhGKRkJfjP2kU/KhUcrtsBmo0RaS1Sp8i53+wzkolhEHDQ664LdPbsfkKo
	 6Ys76eByGtBrYA+EQH8CVhLyvS7t9VMuqW83F6CszfpK+aCWXx4HHZR/wMBZOLAT9D
	 HZ3xy6R3TJ3tVo755lXh2w+HprtTTumKLR9jZuCRYZZFy94qaC5cg14R+RSHNE6hHP
	 c4hKd+oUyrf9Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A8E62C41616; Thu,  8 May 2025 06:03:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Thu, 08 May 2025 06:03:42 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pakap82186@exitings.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-2psPr0Acb9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Wheel4x4 (pakap82186@exitings.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pakap82186@exitings.com

--- Comment #18 from Wheel4x4 (pakap82186@exitings.com) ---
, Wheel4x4 is the brand you need to know. Known for rugged performance,
innovation, and a passion for all things 4x4, Wheel4x4 caters to everyone f=
rom
weekend warriors to seasoned trail explorers.<a
href=3D"https://wheel4x4.com/">Wheel4x4</a>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
