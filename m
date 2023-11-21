Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809F4643D
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvVXRDSS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC95BC433CC
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2023 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700573415;
	bh=i7N+Y+xTcNH9EPzBCP+UPhcL5NsDps1FQiJMk6yHLyg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LvVXRDSSRP9cfzF+E2JY2awnUNsnvJNX9q1hEk+ZBxQhGLkuSATQU3AROnkJN/9yh
	 iCkYAZSQqv20eVgR2wynHq65M99E/XOQvUTIZ0J7JgJF5JzEcTXLAd89DiViock2qq
	 8e3cSVGnn3eAYRRBn336sX9pHswCb+rEguoDIFMRO3QOc/hsjo4fZlpl1++1vZQ30Q
	 HArivbiNfv8Z0ce9W01m6Euzn8okgmDnk21rGRZXRjHWWW+33/KIDcpfKzeporq1gm
	 FlDNt2Cg6gdqXsx7iTADLVMc82QN0JZYHEt6vlt254EcZeGTKzgpcHRluvHKv67gMl
	 fcff5jNzLHfnQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DD178C4332E; Tue, 21 Nov 2023 13:30:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Tue, 21 Nov 2023 13:30:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: joop.boonen@netapp.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217599-11613-eoNDW1iChH@https.bugzilla.kernel.org/>
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

--- Comment #31 from Joop Boonen (joop.boonen@netapp.com) ---
Created attachment 305451
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305451&action=3Dedit
The kernel.log file wenn the system is hanging.

The kernel log wenn including when the system hung.

The output of: cat /sys/class/scsi_host/host*/nr_hw_queues

root@ganeti-node2:~# cat /sys/class/scsi_host/host*/nr_hw_queues
32
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
root@ganeti-node2:~#

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
