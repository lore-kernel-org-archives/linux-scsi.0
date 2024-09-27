Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143D413CA81
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2024 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462231; cv=none; b=oXgrjEozDt41rhBexowJPhH2pIrUu0XCZklzApVYzqMLj8yG4aRi+IlMz+ftnw5i/9MZPH4EvzLJZVxjXAaIl7d6cNOVeQUIyC3vT9Jt1Drgm4RJrhEtOuyPB3UUoLaZ/velL+GmnCvviulDvnDNK6oi185d4lnSwPRlpfMzC+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462231; c=relaxed/simple;
	bh=1EJfP0LC25VgIQM6rty2NwPaelUoB+oMQcCaGZR0PEI=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VsGIR6RZGjf5Y1V/awRcoZqcCgSWHnRB8t68C4VOzLpAAFbajDhR22RkWzOm/ATHW/TRAzd6DbjiJeC7rmKwsrgiQqJn8W77r0rMuBLSymnSe+AZdFrKlK5i6F/2XbHUzKQn49AOTbdLfLk6zQCbLZqjejfnbUCq+BXZ5AzgSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCycFaOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCycFaOl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D293C4CEC9
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2024 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727462229;
	bh=1EJfP0LC25VgIQM6rty2NwPaelUoB+oMQcCaGZR0PEI=;
	h=From:To:Subject:Date:From;
	b=UCycFaOleLUFTfvg0aNxHNjTez8XMNJipZbB0Am9VDBlijuJZWcOrt2b33BEcbno/
	 yz4dWJZ4u5Smaglxv4HfXXcKTNqviLG8Yc5FwgmDUwC8gUSqQ1AQIXiAaiemzbPrI/
	 w6n+6ZQ5ShoTOhyyN0Kr1PhQ4XuAVB12tXZgpng8G5dOtIbNI0yszOnqyVoxKx4iAb
	 72BuxeChJ1wNXZWiOIQMj58iC9XBl3Zpp98r5VX1WA1MmQGRBi6WiJV6JkDjnZ2ras
	 7b1uUTZbImx9TvBFSI3hlR78QMsj+zrm4OayXDS/aY4vpJF87HCkOlje2OjlBGJoag
	 j1ak2DVQwOCMQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7B677C53BC5; Fri, 27 Sep 2024 18:37:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219330] New: mpt3sas add 1000:009f Device ID as SAS9300-4i4e
Date: Fri, 27 Sep 2024 18:37:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: me@ndoo.sg
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219330-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219330

            Bug ID: 219330
           Summary: mpt3sas add 1000:009f Device ID as SAS9300-4i4e
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: me@ndoo.sg
        Regression: No

I have an LSI 9300-4i4e that identifies with ven/dev ID as follows,

```
# lspci -nnv
[snip]

0004:01:00.0 Mass storage controller [0180]: Broadcom / LSI Device [1000:00=
9f]
(rev 02)
        Flags: fast devsel, IRQ 379, IOMMU group 9
        I/O ports at 10000 [disabled] [size=3D256]
        Memory at a400000000 (64-bit, non-prefetchable) [disabled] [size=3D=
64K]
        Expansion ROM at a040000000 [disabled] [size=3D1M]
        Capabilities: [50] Power Management version 3
        Capabilities: [68] Express Endpoint, IntMsgNum 0
        Capabilities: [d0] Vital Product Data
        Capabilities: [a8] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
        Capabilities: [c0] MSI-X: Enable- Count=3D16 Masked-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [1e0] Secondary PCI Express
        Capabilities: [1c0] Power Budgeting <?>
        Capabilities: [190] Dynamic Power Allocation <?>
        Capabilities: [150] Single Root I/O Virtualization (SR-IOV)
        Capabilities: [148] Alternative Routing-ID Interpretation (ARI)
```

It seems like most 4i4e cards identify with device ID 0x0097 and I am not s=
ure
why this card from the resale market identifies as 0x009f. However all visi=
ble
labels indicate it is a legitimate 4i4e card.

I was able to update the card firmware to P16 release for LSI 9300-4i4e from
the Broadcom website using sas3flsh.exe from DOS.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
