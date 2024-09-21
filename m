Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA3A17C61
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 08:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726908341; cv=none; b=N7WovsxfULg0QEXihUdHQqJGkCqHV2/tR0K09tQuKWXGkXtMg1kdAgUVHLpT4xyCH9HUnHh22cnp5LM5IBoS6J+m+JCOxxYZVIfR7AYHh8DTRduprFZDrobayU/y1j72lPnOkRxW+1jR+HmqA2vP22mflEoOPmirBuCfKNqeHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726908341; c=relaxed/simple;
	bh=k5zLRomjYn8sa6ULecAuhf+r2saZFVe4VOWFC0VfM3I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LdMmOAAfn+jx6P6APYCNWcGA6ekxbvWHADFw8t5d3APx/sRgXCXZ4tVvVDED4yJ+SGwDR+WiUWY3tnYLBJ9U72uKNVS6UXR3DJml+6yiO008HXCWjQIja1jaoczfjuboB5T1Z0teoGtvzyDOl47AZEo9hQkpuv8rDEXYjXuhZm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZ01kR0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZ01kR0q"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4344AC4CECF
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2024 08:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726908341;
	bh=k5zLRomjYn8sa6ULecAuhf+r2saZFVe4VOWFC0VfM3I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SZ01kR0q9SV0fLRl5FVjj1dYb5g+ox1csl49UexFRW6+xSWBwzCVv6tjggHCTQOut
	 nco5ZAgsJJXmrK8syh1mcjUl3G5miCvklHY3F157wmYRVkrWQQbwzaTcGrDfBJdnPE
	 jUA4oSEpAoqMj7N0jrsdb+rS6qyD6KNBEZNZ35Vuo1Iu+IASZHsFgLn7s1hlcIdMq4
	 tvBuj6NHcAwialJbzsJYhZRA8tahEcs7sQnWcufAnjU+DuoY3X+I2VB8zo5mpeQ+PT
	 2FDnrPz4OUntcJgPxZ72D8HMGYxPsETogz5/eghwfky9o3XjGa5GbnVncDNSGVHp7L
	 nHo7P0fDvWGnA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3DADAC53BC5; Sat, 21 Sep 2024 08:45:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219296] libahci driver and power switching HDD on newer kernels
Date: Sat, 21 Sep 2024 08:45:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-219296-11613-kcU05Bwcuj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219296-11613@https.bugzilla.kernel.org/>
References: <bug-219296-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219296

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|6.11                        |6.6.0-rc3+

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
