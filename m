Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8616914F79
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9n7q3kP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04776C433AB
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702895393;
	bh=IJE2qAtloBcF2JrgNOhC0d462taedDfkU7Q8sxbi/c8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=e9n7q3kP92xXU2A9jpOVd8hy6+k9MUqySeeoEgL3SpIciyyd8NEvq1zQt6AXhfaHz
	 7Aeazg9pr2HA8hUuk5FAKcls1r5vrB0PfyMl1a8f771crdGPyGLtGIEXCJ0E5Emi8T
	 1WxbED1Nvsig0qmJ0VnMN+1xVNf0kjnEUxWGrwTCmL9rviIcsNPOluK7UY7/ALzF5q
	 f+V6F78VpIRkw0wKSvlRci1FZq42juaDXYauBmS97yyT8RIX9D1LWl/a8KNVBOD2Vj
	 5NgpGdPFEflSI8Rtd6a3NXaBqXiGwsc67sBh7njpWknOdeoLp3RHoeKDv23znrLu8b
	 5wBNAHxjLBDaA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EB20AC53BD2; Mon, 18 Dec 2023 10:29:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Date: Mon, 18 Dec 2023 10:29:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: dlemoal@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218198-11613-lIcsm6LizR@https.bugzilla.kernel.org/>
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

--- Comment #25 from dlemoal@kernel.org ---
On 2023/12/18 19:18, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218198
>=20
> --- Comment #19 from Dieter Mummenschanz (dmummenschanz@web.de) ---
> Hallo Niklas,
>=20
> thanks for getting back to me on that.
>=20
>> Please consider writing to the libata mailing list instead of using
>> bugzilla, I'm quite sure that you will get more eyes on your problem
>> that way.
>=20
> Could point me to that mailing list please. I can't seem to find it. Do y=
ou
> want me to repost the issue there or is it okay to just copy & past the
> messages from this bug?

For any subsystem, you can see the emails to use by running:

scripts/get_maintainer.pl

So for ATA:

scripts/get_maintainer.pl drivers/ata/
Damien Le Moal <dlemoal@kernel.org> (maintainer:LIBATA SUBSYSTEM (Serial and
Parallel ATA drivers))
linux-ide@vger.kernel.org (open list:LIBATA SUBSYSTEM (Serial and Parallel =
ATA
drivers))
linux-kernel@vger.kernel.org (open list)

Given the high traffic, no need to add linux-kernel@vger.kernel.org. But pl=
ease
add linux-ide@vger.kernel.org to the bugzilla case.

And also please add Niklas and myself.

Niklas Cassel <Niklas.Cassel@wdc.com>
Damien Le Moal <dlemoal@kernel.org>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
