Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428824F30C3
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 20:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790801182; cv=none; b=BbdPOk3Gw919sjQLZttw3VE3IJaMCMwcUp1d4DVP2HnkUDd7eo2f+C3eKwPmO3o23HJHYN0AE+qUkmVYGvsRsXHvLoClAdC3bwVUyDn3IdoFo9ERX/qENvzWoSiVFhJXVCrRl6ukswX0pCIVruB800fVLeqn1yQdXb65hMNBuK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790801182; c=relaxed/simple;
	bh=eu54u+1yuqJ2uM1V0EQ4RSe6S/GN31UbUlZ+A0kk4Ac=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fagAdRy0uv5t2vQydmGc5eeG6Al7ZyAYu/2BeWe0YNB0/WMZYa42mli8ptRR3oVp4JO4ihmYjCGvygT6h6l51Yob+rTjFHIhHHoygJJrvgbTkP4BdRxlY2bA7QF0U+dB2ncbQh0vjE+TH9ljJy1Dx+/s4cqTrC+Rpk36Op07+YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ax7Z7sc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ax7Z7sc6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB4A6C4AF14
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 20:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790801181;
	bh=eu54u+1yuqJ2uM1V0EQ4RSe6S/GN31UbUlZ+A0kk4Ac=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ax7Z7sc61/YwzApQFKI1n5Use6oX+S0iSH+ws+LMc5zSyjtSxJbQyy+oCbif8rfKs
	 8Is/t9AQ575NWyWVqszbCcDsKlDYt0jrtgQSQ3/xb3oA/7y/NDOG+YszxS/XNUlUuL
	 AWyTEgtASlZZw2tiIpZsnEGcjbq5vh03JO9Hl8OZKQlzXPhv+Fuy3Js3UUQENi7gYY
	 W7LjKmvKI/lGvGxKCY3KwXAcLI98lrMMsG9Npb2y1LbOtnNTjikkwQM47PseyZswxw
	 VLdM02xFQr4hz0IDHB1zuxL0AxmTOVVOYlBGpHoc4luvqo5CQCWd5cVfgKzh5Di3WJ
	 fKARQwudH9Kyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9F973C53BC5; Wed, 30 Sep 2026 20:46:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Wed, 30 Sep 2026 20:46:21 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222016-11613-EA2m1g5gkY@https.bugzilla.kernel.org/>
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

--- Comment #22 from Richard Narron (richard@aaazen.com) ---
Kernel 5.15.222-rc1 works fine on Intel x86-64 and x86 systems
                           and on AMD   AMD64 systems

When 5.15.222 is released and I test well, then I will close this bug

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
