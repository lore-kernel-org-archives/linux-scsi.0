Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DBF2FC5B
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CjeBm3vU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65EF5C4339A
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700750361;
	bh=WYG85fkpmhe/8WGggJ/rSA3Et9cQjDpz09zSR4CkZLA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CjeBm3vUkK5YdA4yv6ILJXnov8woaty5N6NZ8iHCPo0O3QuyDATMi13/A4iV8LJH1
	 quB5Gb6rHUQ8/PBboAnkBto8jS91sHVh5yhoc/KWJkac/8XGnQFe2iddWsgkaoVP5F
	 WqPIBO3LuFUlT590e37QzAzltBVLbsF9STK/cOCacVArEstewiI3X2AXXbV5dUHMsk
	 rwDLlA7b5hVTSy8baLAgJ0eFuoEj6DexaIEjjQNM2nmzhJkIe2izoEGq0ln0Bd8f4j
	 W1PDL/mVFb7JmVR64amDgG6b6eFBiZJBQVayW9V0tII8QA2gly/GerQ1r2L1BhkhaM
	 gOBrv/7r8J8+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 566FCC4332E; Thu, 23 Nov 2023 14:39:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Thu, 23 Nov 2023 14:39:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-oL40uNFXHP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #36 from Sagar (sagar.biradar@microchip.com) ---
Hi all,
Sorry for the delay in response since I was OOO.

We have tried to duplicate this issues on multiple servers with no luck.
I will come up to the speed on the latest activity on the ticket and I plan=
 to
attempt to recreate this issue on a server with more cores to see if that w=
ill
help us dupe the issue.

I am actively working on this and I will keep the ticket updated with my
findings.
Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
