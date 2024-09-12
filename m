Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4BF18BC07
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 10:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726138442; cv=none; b=BalssY4qACkYSPgxL5Ap6yw4ATxZuDeyDmX7IDCZRWDvXyL6v5I4AOP58BzH6JzqlGQ6ZkSlRkmo5akTXVY6eBiw1cRDz2I+3E+PWhBYqx6jWuB/PefS6NyRqCivBJWP1b8fWw/ClK7J9dDebgS0N301xJCMU+Oz8QXtgJS1e50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726138442; c=relaxed/simple;
	bh=BFn2SQNiM0kPcAYXA4oidawO+m3oteE/WJFl4pUaaFE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DzgZHazKbJofXNaG9d543Z0D9X4LvfPGWswLBRGmAM3ZDU0/S3neyKPMkctdjtSvn65eEjGAhfZjUoK1LwEzwoERuqWW4xn6DcLkAoRvUslsh+Y0AbaTbl0ncjEzVj4aKVeKd3kQNYm6FzTO08HuMxEq+uiHNbhOlsGh35e+ASw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/rVLxS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/rVLxS1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A809BC4CED0
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 10:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726138441;
	bh=BFn2SQNiM0kPcAYXA4oidawO+m3oteE/WJFl4pUaaFE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=J/rVLxS1NzZbuR6mczzsoMzVg0bwjw8hQ4GBy5ZgX3HeKYK406x5yKlbfANFuB6xl
	 1mpX9RV+7A3C+zYmdXEvEPQFjBtkB9maSVUU6W7KxcVE9SqT2yasWByhiMkW/Fp2JG
	 SHDKmFqo7NEJavlvfueNY9hOUz0/cU771uyHf679m2r8kX5mT8dfKzFdQd+exxfSHd
	 o5YO2xNXV6ps0PyI+4fbNT2wuaarJlrfckXIQu8lLW19v9twPTW5gycjBVn43SNWo8
	 WyxdFX9Fw9x0AyI1+Ulg+EfvDfEsA2XdJYaQAZGxi/hxqOKmKhbC2E/onZu5NT/jS2
	 xY7webPscyovw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9D361C53BC3; Thu, 12 Sep 2024 10:54:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date: Thu, 12 Sep 2024 10:54:01 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kennethjoyce549@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209177-11613-jrjaNnGmwr@https.bugzilla.kernel.org/>
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

Lonnie Colon (kennethjoyce549@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kennethjoyce549@gmail.com

--- Comment #13 from Lonnie Colon (kennethjoyce549@gmail.com) ---
Although I haven't been able to confirm if this is a known Debian bug, I did
discover it while upgrading from Debian Buster to Bullseye, using the follo=
wing
configuration:

I observed the bug when upgrading from Debian Buster to Bullseye, running
5.10.84, however I need to confirm if there is a Debian bug for it yet or n=
ot:

    System Management Platform Debian 5.10.84-1 (x86_64) 5.10.0-10-amd64
(2021-12-08) Linux kernel

I can confirm that the "mpt3sas.max_queue_depth=3D10000" option was success=
ful
there; nevertheless, there were some strange (source:
https://geometry-dashonline.com) and maybe cosmetic mistakes that I will
transcribe once I obtain the text.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
