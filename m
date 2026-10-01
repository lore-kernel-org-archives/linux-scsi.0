Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DAD42BC5E
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 13:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859647; cv=none; b=XxC6zP8QcvJ1BwgDj5Q7qNnvF17YbcyL4s70QtAGoCWLjAEWJV9TrvwGP0/QJupfxYxA+1P6tv8vTsLcLaZzBIdzcn0O46uX76r0UugkwYdgKBiMRtUsghvT16LUfg8gwYsz9akUiyc6uJa3D3CTvVaZ7QDV1Lcm7vZpOBFpAPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859647; c=relaxed/simple;
	bh=eNdCFyTFgjBQVSVbbVdEJYuEbUIFp1gS9STo0QwpMYE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZF+YsC9Q2JFRqxBOOqorEpVGcTPFX7ELIIw6SruRtBlDR/Ey9jLYjPzZJoUlOvIUO7hahrj5PFJTxouHTj35G7W4vJGxgTqDmx94dwHMS5A0KxmRn5qORBb69S0ZDPtWn20l4g84WyEw00cxVcYPOAd3xnAXNc0SCYmnqdu/kiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEQTaRul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEQTaRul"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33271C4AF14
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 13:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790859647;
	bh=eNdCFyTFgjBQVSVbbVdEJYuEbUIFp1gS9STo0QwpMYE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CEQTaRulDQktZM3HZuenc+Xz3JOa1q459KGU4lDWGtRjKdhvP792XKb6X9urm36N5
	 wlLUlSAU+i0l/Memk/ajFVsq3wPUuyDV2+eL/0kjNYTAt5RyIJNBurqxfYHsPGe3oi
	 Yn2NSmnxN6bq9JpZNTVkuqBtsrd48HCJ5yJxVF8bYeYRQdJm/ncC++9TI2mha5zkWJ
	 r2mnzirhEUrOglfcxVPnIFMcNldx+KatOwaRptdtKjq9M/nrRIfDg0CUkswUn1LZ5v
	 ksuwsBhWtnNxEV4EAPVtMWfku4UjoeeF2sTXln0QXssYkSLOM1q+6IkgfspHFtIKDl
	 gfKh3UMPXRB5g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 19EE6C53BBF; Thu,  1 Oct 2026 13:00:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Thu, 01 Oct 2026 13:00:46 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: marcop@gmx.de
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222016-11613-GsYmSYEiZQ@https.bugzilla.kernel.org/>
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

--- Comment #23 from Marco (marcop@gmx.de) ---
Can also confirm that 5.15.222-rc1 looks good to me now (tested on Intel x8=
6-64
and x86).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
