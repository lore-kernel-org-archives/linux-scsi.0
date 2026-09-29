Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87399471243
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717610; cv=none; b=fC69Sxh3UbyqQ9Xig8Fys21PFYCCzDrMpA2GB5rvngEzP1vTOGRQiohhh9R4MXWqy8/HNra88weOU5+LFwz/XF88pWxLhwz/3Y9wAZipv1q9dsplmSPmBGpUsV0ByGSGkllVz4Iv2IJZi1C1U4CnENTuXi7VFdshHxK4xKlMik0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717610; c=relaxed/simple;
	bh=nKm1xiyTQBzk3Uu3otSQMQ8VZ1A7iQNDr3b8/iOudzo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nO0xpobd9Z9bwtOEArW/g+WMDCpgLT8apfJfgRu4I6ngg9pjltN/v9zktqt1cxq8R1XbEd21FZJttFKpMVb4VW6GN3lr/1yySlI2RVUo7tJQSFjmugFun8DTvvENMKzyCqwEPE3Q0JI94wH0l0RyaIXT/tXjKCPswwR+b6W1EGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQo6FGv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQo6FGv6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAC67C4AF15
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 21:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790717609;
	bh=nKm1xiyTQBzk3Uu3otSQMQ8VZ1A7iQNDr3b8/iOudzo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SQo6FGv6jzgoJcGRUgk01H+NjX10Ppe0MksqJ+UfWnSh5JN+rd1V6gD84DEmkd4c5
	 ZxCm87/Pgew6U4yP4oiolTyMjr6my3uUzWjfPunE6Q9+8JU731hFvkqz8n6EeCPmDQ
	 SJFcF5QRtD2MNPcH4Xe2d5Wnp4w6p31UDn6V3guJgZ50QDrrcv7ekoaZMIFkmg7Kg4
	 A9XOYOrYWsZySecQrglZPfseRt6ktVAIcgQn0TYeUMk0zTptHYqpgXGqQJEb1+r6vD
	 vBgSY3QDTYDboVzsmhg3yAIBTnepYuhnBi+8vQCg2shta9jJhLJ1rQjX/pnV6+UyO+
	 fN0oByZVUOBhQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ADA6EC4160E; Tue, 29 Sep 2026 21:33:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Tue, 29 Sep 2026 21:33:29 +0000
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
Message-ID: <bug-222016-11613-4uqPbJHgkG@https.bugzilla.kernel.org/>
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

--- Comment #21 from Richard Narron (richard@aaazen.com) ---
Where is this 38803ff4fab8 patch? What is it?

Can you give me a url for the patch?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
