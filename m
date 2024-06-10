Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A482AD2E5
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 06:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718002294; cv=none; b=KZfYRMT9I6Tn73Un3sljTHRU4m0mv9jMNzw+LjTcNXOezZqB8SYw5kwQehxQdqMxJnRfLg1kiWSujxTwY5QRNlVBXNUzPVAtbZ/KFp0ww4l4Q0WFKswhUMjCsoAeD5G6OBy9FRhOu3D4Q1iQwlURuY54RVMPLTOOchymNVYnGAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718002294; c=relaxed/simple;
	bh=w3kCAyFDuxqxq7Q5nU/fWfNxcN1Jkm5TRPde4gIm/8E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tyFfRnolJSdKY3Cnf0W/l/eOd3xmMTC+tOs2rSoIfrSqnvjRHruAe1fe039Pk1nYSFyufmfH5fL76uG+saywWbzT0JTlt5lSZrlzh1MvURtg+AJ0nenHB5e69Lv78cnDmZWDZzqRaeEmSurpPsI1iN7ydDR3xfcpbztMF5NI3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3e/Kmct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3e/Kmct"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 076D7C4AF5F
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 06:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718002294;
	bh=w3kCAyFDuxqxq7Q5nU/fWfNxcN1Jkm5TRPde4gIm/8E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G3e/KmcteKp7QdSUoNrCbRvG8cWUDwTWVlxumk607NoTLnpSaTqnobU2hjtIflBde
	 cVL0Nwzj7LfTDB//g0s8tazig25Yj76NhcRpUDjzjPoMDp2Yzaw3qd1fI4iYlkiu2/
	 nIPjHDXNBregmBzepRGY3tWzEWc2VKp+25PLm0znEIOy40qFH/RcamQDtjva4EJpPj
	 asrvYz8W8fu4pJyE9PU2FCYG25Ii+g6iZHJ6bEsBUvrAcUthTytTr39asKFJ7DVqPR
	 eHkhqTguKeXDY4lJh6Qiivwy0Tt9YNTEQX1D93QuwsQd582tAQIjNUJxQFlxJDVTq4
	 vHIekkb2vxgpA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F3D23C433E5; Mon, 10 Jun 2024 06:51:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Mon, 10 Jun 2024 06:51:33 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: jamie.bainbridge@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-60758-11613-PiOfNYMqJw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

--- Comment #62 from Jamie Bainbridge (jamie.bainbridge@gmail.com) ---
Looks like the repo is here now:

https://github.com/dracutdevs/dracut/commit/faa17f09218ed7e2ce4362cc2d9319f=
8d5b7a37f

It's been over 10 years since this commit. I don't remember anything about =
it
sorry.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
