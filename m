Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D6E184D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722914176; cv=none; b=MHaPSZG+VMh+P0U7dQwZz6KpNYn/OZl/IRWmgLVfKChfs61YkR8zMUAsY2XhMwl9zl/lHXN0PMdM1XSA4dOsRz8Q1WRWMz0B87zLhzKuGA+mH4kIXvDl/e3TefgQGy8fzPgabCnD2RgabuJgmslleUljsv7XXOBtpjZxhoNTN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722914176; c=relaxed/simple;
	bh=sSEWZoOOtGIBFfQ/MK0TAmS8m9Ek0AizdGBXmzLKDdM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pa4zXWo7fDKOg5ZN1fBh2nnEc7aO0yaKd/iDJakeSruTcXLUDHCf+pmtBi2tK3ZJuqrUdtCtyBwQjcRaWAgjKl91kxfMZaR2xQvmTf2u+jRwnrtbTRu2hyrn3bx7dYJNJ/id6VJfPr3zsatvxvNZJ3io4ZsVH29wFQiBDal0QhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmFb4H1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmFb4H1y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACB8EC4AF0B
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722914175;
	bh=sSEWZoOOtGIBFfQ/MK0TAmS8m9Ek0AizdGBXmzLKDdM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jmFb4H1yRmA2HIat/PPM93Wt5HUtvsZYyp2O7sETIUN7wqijLaD5mLmmXeGCBEtQu
	 hcCaBbcbrAcN0UuxFJY94/Zkzqw9kir60mrqqGiJpebUlc3BfFQ8kBW+9eztm8hX8Y
	 Pj2yoEyGEIBxkLDfDi3zvGgt5unhJWoD7B5RR4Wu3aTmSzgsSj2VW4tG0aZ4I0ZDNi
	 USbdrRXQOs7XTE48fYTslDZsdUH6UHaUv9mT64r+nQrJrpTACwUPeEItgFyrl/HGG7
	 5ZlU+ClLJ+rUrIeSCQABfgvWzQlZC9DWfW8Kmj7FsDFEiy3foSAiVO1fNpXVlhnQ43
	 BPGxvV/x2eCYQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A4A78C53B7E; Tue,  6 Aug 2024 03:16:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Tue, 06 Aug 2024 03:16:15 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixc17@lenovo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-219128-11613-jitPD5dezu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219128-11613@https.bugzilla.kernel.org/>
References: <bug-219128-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219128

Xavier (lixc17@lenovo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|lpfc driver reports failure |lpfc driver reports failed
                   |message                     |messages

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
