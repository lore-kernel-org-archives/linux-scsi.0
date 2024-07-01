Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A322316C860
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719846313; cv=none; b=lDDB2WUAaQiE9pBKR/r7GUMMiykam9cbSGo8Sgzzn5R+4K9ZDm1y1qZy3KHgXVXONjA8/VMhDvmTBVAv2wAB8Q2iMbsn60SOMdW+TbJb+XS04NdhvMBxEHqbr5UMrqFMdjOi1lyUNY23rEZ531dyStcPR08MSaXPsNRrurobeUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719846313; c=relaxed/simple;
	bh=T/2PX6zx4WXK7bfrPr84E+Y91nWxjftkFKsz6Zw4qUs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OBeFVn6Pm2+XmosvM+rFntDXCiQrMh5In02fp9B5yXFOH/2qnYAE5ABe08yzGg+9oso7Die6QE3zjaCFdftBc5KuqYXZgXJEdEjqjVD3vo3iryACVh5SC5GUkJrkphHl+abL8SG4GO5APCyxxJtGnmLqPU3reqZLy0MZfuSsH6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7JUluVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7JUluVF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C7D4C2BD10
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 15:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719846313;
	bh=T/2PX6zx4WXK7bfrPr84E+Y91nWxjftkFKsz6Zw4qUs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q7JUluVFXYT68IeSRzJRNlfrdsZ86MY1bNvsTHrutBHi+5JG8Crzk+nU8EONK7q5s
	 NRNzqTCwV6l8BsFLgg5CGNkQesZaflZqJcxgBesz1QIKNj+HZOBfQRCvobiOvg+kW7
	 Wo49BENrFIu7qXLp1VMM4nvK+K/QvnDwCEHerHPl9MUdHw5bklCGVW1wb6Vz/xnhEh
	 sHExDzUjIfMeTSkPbnaawQyuwvOMngE4FE2xzW1cfjXWz9QGQcc27L3a6KlffECy82
	 5eGN73kZ5A8wUBHBd2u1P3TWZDAvCHVq7tlEc6Z04+exfNz1hpnk+UlqJ6czCP82vD
	 feRlzIDQRx8xg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 33A8DC53BB7; Mon,  1 Jul 2024 15:05:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid when more than
 15 partitions
Date: Mon, 01 Jul 2024 15:05:12 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218866-11613-MdpCN7ADqN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |INVALID

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
