Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FA716D4C3
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718957705; cv=none; b=MKvbQXD9othf7/wMVafX+nYyVQahj/zWuXBbcOTg8M8jpxsaTplOf48E0S3pYXiOEoimbP1WV1DPTYr5AZ2fFHtsPQzHsMbTPO91OZuaUZxCYJw5pGs9Cq/svVASHPiTawPGzr4mgfSBdLDFLBwamed9hFiLuTHYdfaXwf0EHb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718957705; c=relaxed/simple;
	bh=lF+mp/tSOQgIofB/1/dV5lGQq8BZi/WLmFWVs8GoORw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s82xAyZC8gPapHTdLyShkdJhgqc3JxEfTwH77hnEaPPOg+5GDuccAPJyAEYl3FtJT1Ti6juoeVt3TdHguj9xP5mheVvu1kgqXmpmg2HfW0KiRemfkB6WZMbDSieQngPTU4sHj94svn4Xs0/VUR5f9po/1plXw0h8ovgHqJGzq60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy+a1dY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy+a1dY1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A70E0C4AF07
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718957704;
	bh=lF+mp/tSOQgIofB/1/dV5lGQq8BZi/WLmFWVs8GoORw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jy+a1dY1xDDTw4XyoOiyqHfexxM5X08wI88f/JWzYacPyCJtpHYZcGTMcs4/UVkLB
	 Rl9c6YB2Y/Uh4pyVXxif5D7BF3hUhP9QHGYHMK7TFJBq7WBYt3lSwDhUNw6wD1vFXf
	 QPIT2nMmw/HvL2F1lU3ZJ1HqwF6wOQCdKkruYLOx5g/nGS1WctDahMxfcNdoMTi1TB
	 BvwMRUZpobncphq1RZCQbHJMXp0oiFehRJYyqfc/QFSh18ubJPQ85nd0wceDa9rKYU
	 357x/CpUYbecP2N7uZJz/7W63K/ew9FAsKMTkrxss5aWm66IKLi64CXbfy928y5ruf
	 OTV4drBZ53sKQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 942F0C53BB7; Fri, 21 Jun 2024 08:15:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218866] Extra /dev/sd.. entries for a fake raid on Z10PE-D16 WS
 motherboard.
Date: Fri, 21 Jun 2024 08:15:04 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: MD
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc_debruyne@telenet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component
Message-ID: <bug-218866-11613-RVQCPYcNSf@https.bugzilla.kernel.org/>
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
          Component|SCSI                        |MD

--- Comment #10 from Marc Debruyne (marc_debruyne@telenet.be) ---
Changed "Component" to MD

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
