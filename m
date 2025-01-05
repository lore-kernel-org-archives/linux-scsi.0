Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81795224D6
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jan 2025 06:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736058742; cv=none; b=VFVuJnv9bz99r97efZP7MS09AwlQzBnRaJnX49VqBrDT/rZRqMyneRbOjttbfGqZZiS/KPJvDWgsCZAjJi2CgtVL0vMIgNAkMxccYgsN4nSLRLMgEuxVqCEHOfyt6rIy8QPkuvgcqIff6rxZZj7vYfcVbn4JR1CHsW/Ubc/lgvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736058742; c=relaxed/simple;
	bh=NbCZ7DFjXmcKZD1zBaTTJfZAMy/JVsDelXfLV7te4/M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LNnPBIfMUCnOe3Neafk4oM5I3J0sk64WaKkaC7As5zLoPaB6Ptsz/jDSXmJrpyhpr+zZBGIyjMw4RCwLnujLSLUXCaZd5pnpMej1z9uc73KXpqu3qLbK4ItF3GtRblKhfs6+gEilPE8bG82qtLeHmuYvcEzu0V4TFe8AZHnps0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bw7rawX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bw7rawX0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3D07C4CEE8
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jan 2025 06:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736058739;
	bh=NbCZ7DFjXmcKZD1zBaTTJfZAMy/JVsDelXfLV7te4/M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Bw7rawX0D4GHayXDbZR1dlyzB7rkb6/nZEwSnVyq9mzJEj1MDOlLE9wseaIMQlfWW
	 xfKRnDEHA3jWDKSEqZb7XyKFx4tztFKpgvF/Sarx6RkEG0sOtpMxzZJBssra2VQtea
	 /QFmEAmIUM6HY3Q8W3jmo00X+rzYj2OA8NSB5bWtkQjukF1HobNS2CoQkVwi6AfGXA
	 83qjw7LhtuTf0mJ1HH8tIV7zo/+beBVX9haOFRpwUzjXsUv0TUVKc1Tt9j5FNaQQ5V
	 2Mw1tiZyKrBGR+bQbH99y9VeAreG8N/DALePJHnDWJc5LgOev87YuKZU4TgOfVB8S7
	 kUj0qtTfM8lvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id BE869C41614; Sun,  5 Jan 2025 06:32:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date: Sun, 05 Jan 2025 06:32:19 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wifiti9585@pixdd.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-zmpY08S4nH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Peltier (wifiti9585@pixdd.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wifiti9585@pixdd.com

--- Comment #16 from Peltier (wifiti9585@pixdd.com) ---
The Yamaha XSR 300 distinguishes itself with its ability to cater to diverse
rider needs. Its harmonious blend of retro design and modern functionality,
coupled with Yamaha's engineering prowess, ensures a bike that=E2=80=99s as=
 reliable as
it is stylish.
https://wheel4world.com/yamaha-xsr-300-overview-design-engine-specs-and-pri=
ce-in-india/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
