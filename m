Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9DD148303
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719910560; cv=none; b=GKLoWZSdKN/ZtmbgINq3+VRsCO23vyD2153CdM9RtI+PPaERrAnl7osEeh2UXSJFGUT4TQvVCacOUWb0Q3UoFjD8CX0z6iGHZ4JvDQHdQ650rF5qoHcHI1DQq4aN1g3ff6ihiSBz+OxfKE3F9jVmrBIWzCMDMFUWXwPuRvhgLmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719910560; c=relaxed/simple;
	bh=jSJ6oSTXq35bt1Q2BjPs7wUe6lOqxSVcQO7nafPJMv8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QuJpLs8oNgTFg7VQZqzU5NZJmtYG2BcVtfkQ9ZqUeDgbqDL/cgIVrEbVw759eE4nW+1EC7EVCy3p/jZ/oqX0gt72qQmbSuESOgPMH4j6zX5h4WeVBGS+LT54HMXLBrymNolAtGCzN6vN5GBoIUjP3eXG3sbc+x/aoPJqJoUuOj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L07+vrQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L07+vrQk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DDFAC4AF13
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 08:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719910560;
	bh=jSJ6oSTXq35bt1Q2BjPs7wUe6lOqxSVcQO7nafPJMv8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L07+vrQklc18ZgdqLxtszC77codejfyesHiLz2aHjIlUE0QTuxHy4SFtrvT6laf7j
	 /biUYOXZhynh9Fcc0DiOYhAZRL9oCGZHlc8G0H3cNoCEtcDCZjs4t4M7J9rdb7vNh9
	 jI6ruKv2EeXHjapHh2gtUFPQLEBBd7dtDp0t5/Q4QJ03aEqKxv7js5f6Vlp/oS8T8k
	 Kz6JxX53PnEexTAQQbOcpgCeJ3Sb9VwGZ2SwFzWejnGecr6oWr/7aiknmoOljT65dZ
	 eh6GqLh1Xv4C9YAT56w56v6TQt0O8vbr7YTo7MExnvdNh4OZuNxKUAi8mIFqVghLrI
	 a0uqe0sqLn4ug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 24E07C53BB7; Tue,  2 Jul 2024 08:56:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date: Tue, 02 Jul 2024 08:55:59 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zeph@fsfe.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209177-11613-Eq9rUdmrfH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

--- Comment #11 from Guido Serra (zeph@fsfe.org) ---
@Ranjan is it?
https://www.amazon.com/LSI-9210-8i-8-port-PCIe-Controller/dp/B01D9V14F6

the card is the LSI 9210-8i, the fact that the drive supporting it identifi=
es
such as "LSI SAS2008 PCI-Express Fusion-MPT" is another topic I believe, no?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
