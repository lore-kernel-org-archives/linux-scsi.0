Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC4D2E859
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 10:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716287759; cv=none; b=JDTv3kzAudVSzbH4KzqiOUfGvKMiNcZyk2wk7yXlHk5AEPmsOjQQfkcfzsAE1cadvZOqi8o7f2+YXUtTvty7eAnJ0HZ9LNFHtEKYJF0hH7Lf22/q4yxbcvdditTydXB4rLNM7JIp3SlOQZrEHLcRCBtAKdW9jE4vbfHalMztpq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716287759; c=relaxed/simple;
	bh=rlebzV8TolEM2r2LTK43YZUmGwP6WTLYZeCyXFDGaj4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z6swerksMiRZKkc+YuexJFG9k82stZp2KIraqiOLlEoe+5cU6oFNjF+84p+D3lPtNN8fFW5d4bhRZHy0SlOm4qkWEvQfg2gNlXhpOshckuf6h2ZKdpsTt2XhZBJgPNrFjZGego7C5/aoN49wrIiuA3Zk9g2A5c97lmMjWhOehQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkhFSIgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkhFSIgR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EC85C4AF0A
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716287758;
	bh=rlebzV8TolEM2r2LTK43YZUmGwP6WTLYZeCyXFDGaj4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YkhFSIgRBbVz6xXGDCbwVx75lvcdZCQHaHWuz9d2IPRTqAIt/Hj+df45KlQzkzdKT
	 ua5mChBihhdkV9MRtefsrqEO83/r28GSiVs1v0ydHQhMuZwHbHIp1PND/nhPfZovdL
	 CCnKkj1ObHxNANwyZ3akT7zObXcHl5haFAvc0tszwuY4a1KdZDGwdMsx2ntZV8AnTP
	 B2iPB3gHHQToSiYKUqosp/olFFnpkVMrjBD1Z7qgVhyMOWb8M8fjv+lOIs7+Mb6Rcy
	 zXHATMKXEBIgkh56F6ww2S3MlMq4wLwLfIraWT4mrU/Zx5IdQrG1dLR5BSyG5Rtlu9
	 JrTWREuCE/gPA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 87B1BC53BB8; Tue, 21 May 2024 10:35:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Tue, 21 May 2024 10:35:58 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component assigned_to product
Message-ID: <bug-218866-11613-3tSNEWASgJ@https.bugzilla.kernel.org/>
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
          Component|x86-64                      |SCSI
           Assignee|platform_x86_64@kernel-bugs |linux-scsi@vger.kernel.org
                   |.osdl.org                   |
            Product|Platform Specific/Hardware  |IO/Storage

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
