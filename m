Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558ED24205
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707064640; cv=none; b=d31R1JV+WlPW0clsmVnPQHzzkFLNnY6ygVeIbcuPghzIad/jXpS1ejNPDndWZAAodrhawc3MaaSdYapwX7Zn/CJQp6TANIppzuIJSWxOyUl/IhOMUJYeGdk+0oJC2qkq5FbebY6CwPc3K6gVu4y31U8GK+Eu59LLLLvAQC9De5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707064640; c=relaxed/simple;
	bh=jDfyjnL2jQzTEbNu2k6wMqk6LfSMZJBss1rlkKVErqg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OXW74r1Hhxly0TbCOCy7oFTn0h17iV1JqJ8ogC52Dl+54l8XzoRMtmVNI7aec4Li5v97ebVr6yUprOpADtnlXv0tCmk7T1ntie4tkalX2BFTg98BcKF21c4cUs0PcBkcQnBRgMU+d3nMop2qgTQp4175RSMisXuagizx6BjfAvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqFw8rzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqFw8rzD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE450C433C7
	for <linux-scsi@vger.kernel.org>; Sun,  4 Feb 2024 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707064639;
	bh=jDfyjnL2jQzTEbNu2k6wMqk6LfSMZJBss1rlkKVErqg=;
	h=From:To:Subject:Date:From;
	b=OqFw8rzD3jIEAiof6Y/K3PJTLo4ZFEGGHWXzq4TEKSWd+i5e7Cn+ewTQQKmzpc6AI
	 Q8gohf/68e2MxcqIpae1EtODJdYGdNYv9DP6BH/duSdl5TLmofjO9EVbFK+Q/W3VOR
	 qEtJZ1ALtJNAItLcVhvmEy1TjWDDtXsCaPJD6wC2lNpZPV8lOp3TxCFScpc/nkSGV8
	 5woKQQw1y+ruhMQ0apX1UY1iAF5xXsfYvGhYI6zxAM1tU/WftgXgZTRj39vl8wHPYc
	 4kiULwCwkLNbzReSGWSfMZRq0ZTwX3XfdxF7p1qN0wO4I4mk0Mp36QcNQw9oKz+3za
	 7VuokdCSAqarw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AFAB4C53BD0; Sun,  4 Feb 2024 16:37:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218457] New: mpi3mr - mpi3mr_transport.c:1818:1: warning: the
 frame size of 1640 bytes is larger than 1280 bytes
Date: Sun, 04 Feb 2024 16:37:19 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ionut_n2001@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218457-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218457

            Bug ID: 218457
           Summary: mpi3mr - mpi3mr_transport.c:1818:1: warning: the frame
                    size of 1640 bytes is larger than 1280 bytes
           Product: IO/Storage
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: ionut_n2001@yahoo.com
        Regression: No

Hi,

I notice this today, when compiling kernel 6.8.0-rc3.

drivers/scsi/mpi3mr/mpi3mr_transport.c: In function 'mpi3mr_refresh_sas_por=
ts':
drivers/scsi/mpi3mr/mpi3mr_transport.c:1818:1: warning: the frame size of 1=
640
bytes is larger than 1280 bytes [-Wframe-larger-than=3D]
 1818 | }
      | ^

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
