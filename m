Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC1421356
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 11:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADnqTP8S"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ED70C433CB
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 11:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704368755;
	bh=ZaOKYb7uV8gutDc9S/lzPM3XmCCFirEIz1xYYNvxi3w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ADnqTP8SVxWumeouqzEBxrToKxu6DXDd1pWt88HHvRcFDXorXch1sEtntuGpY3Swi
	 5P8uUTybTLpD4j+qo6o8yEQ0tUD7N2eXuQiCmowMQaH3Y6SM2+Imvdga2r3h80w+tl
	 l7fxJAv4q/zcLsqFVleol+X/v+hu7vC0teqYgRQJfnM37TBg9TURFB9gm7GSDjyRIo
	 wLKNaPAoh9lM2TUmg4dYVulVf7UKY1+HpBcvJpRcn7AbVBPAfH3t2a9FIXND9kcn+V
	 hSr6vv3ptmqAVGQadBNWI2NX55eJ5Pk2rODJLFIz3kADXyRJqOJNkwl6cq3VSGQxee
	 ly1JioFOr0Wfg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5D557C53BD3; Thu,  4 Jan 2024 11:45:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Thu, 04 Jan 2024 11:45:55 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: fatalfeel@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-151631-11613-YGy7HQvdOn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D151631

Jesse Stone (fatalfeel@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fatalfeel@hotmail.com

--- Comment #11 from Jesse Stone (fatalfeel@hotmail.com) ---
I met this problem too, before reboot do follow command
echo "1" >  /sys/block/[sdx]/device/delete

remove device can reboot good! test ok

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
