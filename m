Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C612BDC0E
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791037168; cv=none; b=gmN8JHPFlkrVCyEffd2+in1c4fyaMqCAC1F6l/V4FAwaDDyZukI5i7F5AIQqU4hFHGCzugiAChl6qPfjekEl/EUg48ftQj9uKWW8sGT55enearWvRt0iRadou+Iil3qJZD3+P1bI0Xm8iYEBBCQEaGd+J/ejPno/eK/IPU3ltOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791037168; c=relaxed/simple;
	bh=87/OQ35pr+XsGhMgS+LXGWeNPqwbHUiVxfcyQ30VzoA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=StCwvDbNmLUQaQPat7Byr2qBRa74sfop5rO1anGzZgIv9jISKXjb7Gsx+t8HYoS3fXj7NdQLepGLZv0P4nzffUSl516QcGTvSzxc3v/yT5VknQoq3T5oGkSMyiZSf0i+7T+o2OqLFK4xB/fdqzrzPZCCkJNH8UVhzY2cdRQX5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbxYq0Rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbxYq0Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E186C2BCF6
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791037167;
	bh=87/OQ35pr+XsGhMgS+LXGWeNPqwbHUiVxfcyQ30VzoA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hbxYq0RsD6BxYJYvp06jIhorqhmBtg/mj/1j4UtJnMMJ0caMPaJqc8a/oS9THV0Ef
	 R8AgHlIk1SyhfsV8pIUsXlzg74l3DPPj0Ulz9Xoxd7GZOWUN8Puh+rDfppGofvw3kk
	 u5U82z770LHtf0fLsv74uSlb+VdxkVk6hNpvUO0hBNi2/zhAK4whtZ3k3C+SfX/rdJ
	 e+itDoA5pkwCsxYsAp/abg9QZlA0a5VNwfVzl60v0MTUcPManaNTAUbxhZc1rhm7PY
	 pbtrlZcTwy8tvn5vivJy5cNkN7WxQE/4HJmubyR7ooUsyyoy+kMcWwSB0PS14aC4f5
	 QIVVk/45AmVhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F2AAAC53BC5; Sat,  3 Oct 2026 14:19:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 222016] kernel 5.15.221 does not recognize mbr partitions  and
 therefore does not boot
Date: Sat, 03 Oct 2026 14:19:26 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: richard@aaazen.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-222016-11613-RnDraNK1xa@https.bugzilla.kernel.org/>
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
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #24 from Richard Narron (richard@aaazen.com) ---
I am closing this ticket.

Kernel 5.15.222 works fine on Intel x86-64 and x86 systems
                       and on AMD   amd64  and x86 systems

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
