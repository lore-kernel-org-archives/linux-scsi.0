Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E4C14F67
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzqEbJn9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FD44C433C9
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702894871;
	bh=ZQ0UWFJhf4aHS5ktw4KvZWxV8w4p0P3YMgc2of8jsA4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nzqEbJn9uNHmSZicLjwy5r6GZ/a+T2Bu2/56pUyzIWFYRNXx/io5XNC1yr9NwEcGZ
	 Ud2SWxU+vrG+OVp5W8g4y2S0UMVTB5if0V/uA8Qx4AiPUkvSpeL771qeWlDqCZ+Kss
	 LBr7CpYK0E5zwYvSRbhqWhNZJseDrABpkAQLlro83Rry3Wc/06Fqbd2+wt8OLDIqG1
	 IxVqM7FcR/IXukY1iPXtBeHtE0Vu6CUcxY86Afv4OzX717APQ9SwrVLe6vdvWGcHEU
	 r8ZDQK9uUgnHEXwheZ3SWU+PPT/iguAuGMpa8H0QqJWXO4ZkIzMmdV5ggAA7krlQD5
	 RUcfkgBmuk6fg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 91357C53BD1; Mon, 18 Dec 2023 10:21:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:21:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dmummenschanz@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218198-11613-dtEooO0Nlj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218198-11613@https.bugzilla.kernel.org/>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218198

--- Comment #21 from Dieter Mummenschanz (dmummenschanz@web.de) ---
Created attachment 305627
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305627&action=3Dedit
hdparm -I output for sdb

hdparm -I output for sdb

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
