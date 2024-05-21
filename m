Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E566A57C8C
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 09:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716283799; cv=none; b=eK3wWqUJ+O60LriHXM1FpLbG4ueNTRM0TAT+6b1ny5OsQZyVdd/44SE/nFU46LvtQjNb64QKDuJmTKK4SqGJ/Lm8mnGdevoflvYUlbTSZliI4drwviZ9Qmd+/B+bCSuGJLQe7VOZL2pzt1YFYdwiUhwWn49FB7Yb6EtYuSbVG1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716283799; c=relaxed/simple;
	bh=x03RN+gk338kvAwyOOFbclj73jphNqFab/PtEijHbYg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DTLwMVsjvaAQyx0Lt5h38z3TbY0r7QYuOeeM7pplZUJdU81yIwVg64xfYAquAkomlyjiUsdFg10eO0j/42ppudKw5pwxSZPm0gO2Xntw0co3+ALg/g+EC6ypWnuvO2ePf508K0OzGK2LABpHVTNtmAoGydJMXwqMy0+6d8KjUK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URyvz+xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URyvz+xp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9930C4AF08
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 09:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716283798;
	bh=x03RN+gk338kvAwyOOFbclj73jphNqFab/PtEijHbYg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=URyvz+xpmhBmFIbafwWelVsfJpII+5zv8fyjF+/Xb2Lxg/vf3FAwZ50mzzzitf4aV
	 RVAYt4jillEVc4uahnXeBvpvtBMz0UoJSdAz4BigM/PEYS7iYAjD1LkH6HAywR0KtO
	 JKaVhFzRn0oyiKuI9Arp2x49DehQKXKl69SwygQ9TFdMZPzFr8Vfrs3oYdFrxm+Dsd
	 GPmKpHEX4mqmkCL+c9hKJMo/ba+nbRz8WVg/suhxqvJ9P02HP6Tq0+D/C2niVSqiYq
	 ytZpGl5ueiYdK5G/MJbIWrBhirHIozxJL3HCgdVvQTXO0LUDHCURscrMcdSoy7eDO4
	 v04hTr9wtRb5Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A3473C53BB7; Tue, 21 May 2024 09:29:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 198923] Linux 4.15.4+: Write on Ext4 causes system block
Date: Tue, 21 May 2024 09:29:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xosamop642@cgbird.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-198923-11613-UhaM3aQfzj@https.bugzilla.kernel.org/>
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

Tom Hiddleston (xosamop642@cgbird.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xosamop642@cgbird.com

--- Comment #17 from Tom Hiddleston (xosamop642@cgbird.com) ---
This bug has been marked as a duplicate

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
