Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BC96BB39
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722914835; cv=none; b=l4pxDb8ftTEq0p5TGM0nvgRgINVgkVP11XVaR6X35doEueA72OVYTbDfz6o4+bu7IZmS07D7x/qCoBKx3t7a8FWbkhaXkN/lf8qt/Hmn4b5/kCgYRUm0wSNk8HQXfy35d5PRWtK2nzA8BNzeq9HrtzbocVvmdb1T215CXToWStQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722914835; c=relaxed/simple;
	bh=vENEBHckRxdbtD1bOg6kXolRDbMR7/xW3DZNnS4KJaw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UFuUAI1MemjkM2GCRjKwj8nw4a9lIT4genifrKlYtANVu1dA3oCngH+FgSHdV1nbC9+cOta09GpOy1b6KV5/KZ2rHsiRTsQYOdYmvw9X5BdDnIg1tBwYJEhFWb5AoeB3udIAgsEGJUHm9kQsSMx/1C2aHp69xZeaROyOAwAbUTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fl5Kuo82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fl5Kuo82"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACEA8C4AF0D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 03:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722914834;
	bh=vENEBHckRxdbtD1bOg6kXolRDbMR7/xW3DZNnS4KJaw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fl5Kuo82E9ofEdXR7ut9lwozljKoy8OJNMIxSDuL5SCHE2XxSH0/zzQSCHJGqbwIl
	 6eefmoz7HA5tPJL+5Ulq1TQZJgMB/sJ2wphfXpjq94meK5HtH5Qgf1Lk/0QwZbVOSc
	 YvOCm8zAGeiZkyLTfLWmm4hCNZ1FBz4+hPfudcQe3FRSosaw+lbHONLN4DfhKMMCb7
	 6T7KtH2l/ZFnWfQrhE5caV8CBvyzaQZMsxEriuPyDP2MGg28d7RRIlPEzS/DwTzuha
	 8JrzdoK7cL/GkDBGuSc7r1ejB+KHYnuC0EPIoKWp/8q7wCCU+mQ3OHkMo1qYlbUDQY
	 X+Z1SnN9aMLmg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 968CEC53B50; Tue,  6 Aug 2024 03:27:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Tue, 06 Aug 2024 03:27:14 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219128-11613-ig7VJ5x7wa@https.bugzilla.kernel.org/>
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

--- Comment #2 from Xavier (lixc17@lenovo.com) ---
Link Ubuntu launchpad issue here at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2073571

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
