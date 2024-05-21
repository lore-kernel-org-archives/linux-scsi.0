Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DC06CDA3
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716288412; cv=none; b=tTo2Z9lYxGeNuv+lmR341aeczxs6mkitk1K8tu/sLh8UwJDwkN5HztdsYUygRoyJ0rlIyBNFV+nrh8+TR7kRq+/ViTgtqYeSHTrlNpkzzTAQluXTqV4fS0euj/qr1a5nd9z4LRoC/1KDtQYSxVCj6v6zLUA4RY8w65f7LkpRh8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716288412; c=relaxed/simple;
	bh=nympoPTcGUu0DBzx15mZGL4lKiYNdAX1HiCPtYLuzK4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tflL2DeHt90+6MCMoRfnLezutzz1JC5KdgUzntJSEKDpPZLaWyYsIxdxCbuiwYnl29l5crj277Tr+9JiPK7ynepYddLWgCdyYjldvMq1oQHXqP8vIDX3BoGU6SDraPe20kv2R03x07NdnV+eBQF0oD8X+jcvBgSk2faG7flffkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAqDXIsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAqDXIsm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94568C2BD11
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 10:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716288411;
	bh=nympoPTcGUu0DBzx15mZGL4lKiYNdAX1HiCPtYLuzK4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZAqDXIsmiWt7NKdrEh2gk22a92RAriYKq+DFBLbQPsweuup2TITiCoc6/baSm2tW7
	 +V5sYwYcL3TlZFCq7NpFU2tu92OMpvPKxaKVpcKkQg/lGGD9EldawCzA/ovBCysnHe
	 z/K1WXoTIiVGOdhnaCMqPet7L7KsifvBWpE/3bwDmFUwnjtMPL7CH77tCItV9Zo192
	 WK1HZ+Ktvp8UBjBuv2mdsVJQX8tK94d92nUsN1BOKZZQ6LJmqHLtOF+rnj0f/W2XA+
	 y37eDevTv2RmY+kGfMJOxxFR8jAhDBkzOlsa0X/E4y8VzfUB9ylwiPB6rCAazv4Gnv
	 lqCjdkmy/2PDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 85564C53BB7; Tue, 21 May 2024 10:46:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Tue, 21 May 2024 10:46:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218866-11613-fKIdC2UFAq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218866-11613@https.bugzilla.kernel.org/>
References: <bug-218866-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218866

Marc Debruyne (marc_debruyne@telenet.be) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.8.3

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
