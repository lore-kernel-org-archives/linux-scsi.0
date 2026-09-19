Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B259C25B0BE
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789828562; cv=none; b=ZmybpZ14IJdRYnud6AdRch0vrT0zgdJcqHbDlhEWXq25NM23YcJbyeeM54OwcLRyQcp2BcCbk3ebMr9kCiIyKBH5B5pQScuvjIVAuT/Rp1+qtJBzL5f6Dy2+pZRn2VnT1frZUM4D3nYNHAFLG2zNLr0G5zjQtMc3v9zqYKQl74g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789828562; c=relaxed/simple;
	bh=rpb7BoFiIFyKwD0H4TF4rzzY4Ji1xZy7phwPIdcJGMI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lY/Dyv9nSaRbcEGksyUCpePM/3veRT2bjpe5Ob7mZEYvddvVs+YILUEGqgSf+DNjxum5OOWXjz0wSghhoW3LbSQ/5Fm1NYXJ57Aik8YNlnioXHoNEFjeydVqdzuvreTsPE8ODAcW8ir+wfQzKaKs95aXhgWiSH3+wSMF9hmdoRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnMOlFlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnMOlFlH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B45EC2BCF7
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789828562;
	bh=rpb7BoFiIFyKwD0H4TF4rzzY4Ji1xZy7phwPIdcJGMI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gnMOlFlHBYOIPWOuzr/31HSRyDl5lm4iEzKZDdbzM7W0DZ/SdblZn5ixmDpDAWpTj
	 aJINehj2VfXbPgbiQvYVN3/CmFd/ampQING7akc+m2o5mJebyBfJg7S+Mz3L3L7zqk
	 nmYxLr7TDZO78gByzfVxWgNEQK8BI8UNxlJ1KQKLQVK3UoFxwHjCposx00KtFTu0Q3
	 yEqkS5eLKwMUnkYD/fN0ivzcvYj1ZIP2rz4uXG/lqrokjUCyvfs3vK2KcNuuYJPD3f
	 Cp8LypVz65ebbRCNTxWAyL4pezeRgncsMA8+ZN7H04cVQroFT2FG3+9TSn2dAw2NS0
	 3M54pc8Tqzb7w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 20AD6C53BC5; Sat, 19 Sep 2026 14:36:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Sat, 19 Sep 2026 14:36:01 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: richard@aaazen.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-222016-11613-qllzvVmJMH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222016-11613@https.bugzilla.kernel.org/>
References: <bug-222016-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222016

Richard Narron (richard@aaazen.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|CODE_FIX                    |---

--- Comment #15 from Richard Narron (richard@aaazen.com) ---
Where is the new version of 5.15.x with the bugfix?
I see nothing on kernel.org...

Programming manager John Moline used to have programmers who reported bug f=
ixes
as "done" before the code was installed into production.

He made sure that the fix was "done done" before closing it out.

I'm marking this bug as open until it is "done done".

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
