Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F35C4D9FE
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722963435; cv=none; b=eu7sq+MuL5VKZRojwmmkiZAWIO/lau3eyY0xmNDPQFdyw1054MLgusO9WIm8ne7m/5L58289Xf2MAU5rjMXW783MNc3eGKzwKMEakUfe9GE9GbPs5le1OSn+dTFF7ZOIr5O2+slncVGT4LNmatlfCwNYqWPro+9u2sgVK1oObk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722963435; c=relaxed/simple;
	bh=4he5wpbRRZHI0V/yZW15YO/neS5zwjErH9TPqlfIl4o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TEwDVLzPSIMxekizcCmu8GkVOsAmKJb2A87kefWsgCZI0CmEyrmJ70lDqtFhuhXKkfhJZcDB18K4qketPdh6e8XfyZYeRZzLe0ZIT+6N1tvvbPAe27pV8dJWvphka87ABllmD928qs7X4fasdUzeod7YyQG4JDIhz6fbN19gl+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PE/d0Ii7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PE/d0Ii7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 954B8C4AF14
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722963434;
	bh=4he5wpbRRZHI0V/yZW15YO/neS5zwjErH9TPqlfIl4o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PE/d0Ii7rg0Vx7Lf42VoIKbqQTMqkTOu8oCVq2M+cQDprZbiBhXgpCEcxUXIH++Ss
	 Z3D1a31rKdUYXc/kL1bkBbSOj8bLZl27BExinSeiVnKLGRP24xGOBA9+JQ2AxKbnTf
	 nILufQcLrlqG3JOl1WUmv3/V+vfk1iDRZkLAOoxpwtp1NbpJJKFu1L2XpZ91SnHZEC
	 1Hgj2OrnUtnVEN+Ga9AL74UkFhxRNYnRJK81r2O75hkUPCsCdMylmay0ECrg/nCl++
	 yAQqEXXc095rPqtlm19PRqUZgGD4Ak6TPsHWDUeXH/+FR1bo63Gps1d39VdmA4g6se
	 8S4MeQ5jTX4Ig==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8E400C53B50; Tue,  6 Aug 2024 16:57:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Tue, 06 Aug 2024 16:57:14 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: justin.tee@broadcom.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219128-11613-tb2tDjwuQv@https.bugzilla.kernel.org/>
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

--- Comment #3 from justin.tee@broadcom.com ---
Hi Xavier,

Broadcom (Emulex) will have a look at this reported bug.

Please reassign to justin.tee@broadcom.com , and we will have a look at the
dmesg log.

Thanks,
Justin

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
