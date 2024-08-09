Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C901D51C
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 02:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723170639; cv=none; b=KJ7F26n2WXQbGxKkJv2+FryjrLoDMzl6MGoJ99aHqVoR2zbPK/6rwRhWd+I7IiEHMhaGtU0Qx//7UJh4+m9cVlJ3lii/2mVG8LadSL7I6KVEhSfrF+lSS2JR+gNvSdBAmrL6hNo95EbXNo7hTZ0D6VdGNFONCCD0OeGtvExI9gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723170639; c=relaxed/simple;
	bh=wAxGCAObi0D73h7OnAnFJXquOuhL+hU0PZ4g6kmWJPg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gbQsSYsEVkw/l6qopJEyWzOD1+ms5sKvQNhOedwVtwMjv2fzpNYSSH+vDJBT2rAncRozG2kWZmrMlaQs4oq/tk+o6wms99MGfxPj3bKueb7dXXGK73a4rBdVB+7T/LrpP0QOFE3mu9BGAvmle6UMROlCp0fP2DuO4WLEhYGDBhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNtfvHwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNtfvHwg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F568C4AF0C
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 02:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723170639;
	bh=wAxGCAObi0D73h7OnAnFJXquOuhL+hU0PZ4g6kmWJPg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fNtfvHwg4Gn+vvV1QK666dRhegEygVhrav/GvMxOhfJhBsiqzF5vPK3hxowLH6gOC
	 78v3nOCvNZ5FUaY5z/xGNDVFuYwrTFayBMKVcpSCxjXf/8sSdrVyLNyQdo6u38Vuly
	 ACyWgTHLddsvAhl6FXY0DTeswODmR1RxhsalNk666B1NXifS4E2NmY+eGbXAitLDsv
	 TgiZH8rO61NdWKodQSRMUPfEhiHB6nWIwFfGJ1SUtMnHAki3oj2M2PyF4/YJsDru5t
	 yBZJwfs/PaWD+r5QeZq9Kfm0TJquYv6dpGcy50YtIFJ7yew+JwmHcNloniL+A32/I/
	 35sgswIaNWOvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0DC59C53BBF; Fri,  9 Aug 2024 02:30:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Fri, 09 Aug 2024 02:30:38 +0000
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
X-Bugzilla-Assigned-To: justin.tee@broadcom.com
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: assigned_to
Message-ID: <bug-219128-11613-pbQwiVjFPs@https.bugzilla.kernel.org/>
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
           Assignee|linux-scsi@vger.kernel.org  |justin.tee@broadcom.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
