Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92003BE16F
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 09:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836013; cv=none; b=GlaRnFpNoPOWjxrWdcGUawF1+RiX691dmZiYloImGvW4rYPLnREA3ESjwwiHvJnQNQ1RXqGVB1n1YhvOJmqnBWU0AGgq1A4nCPhZ/ggfjBtkLq6FPsfOhUzjy6oQV22B7GOMz0ZR5Xpu7UeqklgmpwucPoMCuHcHTT45c79Z8Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836013; c=relaxed/simple;
	bh=zpW4SQ9+1Y7bSDdG8Euh/Sgvqf1/ONXdODDsBNbuY8w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jwMUVBDGNmxB5vs6cxpq+kJvnhIwLne4gBSxR7WWu73Y/3KNipHbsuo9v4vO/m3gEX31Kp6X+jEo0TDkUJQ/rDHMHFK1QdiMnxm78bht+mTHV6AegBEPZpuP6aLNu1JNhFxU55d7E+svd3eh1Z+UA9sf3zfIOEiZ3O8qU/BjhM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQoCqBKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQoCqBKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417E61F000E9;
	Tue,  4 Aug 2026 09:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836011;
	bh=xV9+Sj/hbZgtTfKcDBIzoOgIZTPoJ/hwiAEFOMozQik=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NQoCqBKxmNWWXm76HpSpAkAwGeldbNLspTmoW6VFvJXPHEEtAd5MHAy0joPe+aWYo
	 IEJqoN8fpdP3mAWETTPd4DYfiU/9Awl5oHwUDyi7gl1Y1kC9ZcapzXGDLeKC97znAv
	 vbSVLrApqczWKpKiaEuqNAHtHDwW8L273iaTw965OZwB5nIPcy+UUuH6Sqa/efNJSL
	 dcM4DgNDI75Ef7s/BE9REtv70Gnkw76aQPNsHFrGxQCS9qK1VQLoEezQEzHh1EljCd
	 WUJPl4SzvMZX5lLQBJ3QsfJGP6y6D6k2sSUtepEmQO6hd5mgC/Mds1ti7xmhu0LbhK
	 SqMxvCK9uyooA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] scsi: leapraid: Add driver documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongdong Hao" <doubled@leap-io-kernel.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <6dc9239844dc00cd053ea0649cc9fe05cad1d98a.1785823793.git.doubled@leap-io-kernel.com>
References: <cover.1785823793.git.doubled@leap-io-kernel.com>
 <6dc9239844dc00cd053ea0649cc9fe05cad1d98a.1785823793.git.doubled@leap-io-kernel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 09:33:30 +0000
Message-Id: <20260804093331.417E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The driver introduces a non-standard sysfs attribute `ncq_cmd_pr=
io_enable` for NCQ priority configuration, causing ABI fragmentation.
- [Low] Missing required blank lines after section title underlines in reSt=
ructuredText documentation.
--

--- Patch [2]: [PATCH v5 2/2] scsi: leapraid: Add driver documentation ---
commit 630ad4ee0c14f18c620eec6823a389cf9f5654aa
Author: Dongdong Hao <doubled@leap-io-kernel.com>

scsi: leapraid: Add driver documentation

This patch adds the necessary documentation for the LeapRAID SCSI driver
to the kernel's documentation tree.

> diff --git a/Documentation/scsi/leapraid.rst b/Documentation/scsi/leaprai=
d.rst
> new file mode 100644
> index 0000000000000..99930ce2b8d04
> --- /dev/null
> +++ b/Documentation/scsi/leapraid.rst
> @@ -0,0 +1,110 @@

[ ... ]

> +Supported devices
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +- LeapHBA-8200C
> +
> +Features
> +=3D=3D=3D=3D=3D=3D=3D=3D

[Severity: Low]
Are we missing a blank line here?

In reStructuredText, a section title's underline needs to be followed by a
blank line. Failing to provide this blank line causes Sphinx documentation
build warnings.

> +- PCIe Gen4 x8 host interface
> +- Support for SAS and SATA devices

[ ... ]

> +LeapRAID specific disk attributes
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +::
> +
> +   /sys/class/scsi_disk/host:bus:target:lun/device/sas_device_handle
> +   /sys/class/scsi_disk/host:bus:target:lun/device/ncq_cmd_prio_enable

[Severity: Medium]
Does this driver introduce a non-standard sysfs attribute for NCQ priority
configuration?

Using ncq_cmd_prio_enable instead of the standard sas_ncq_prio_enable or
ncq_prio_enable defined in Documentation/ABI/testing/sysfs-block-device can
break userspace compatibility. When a user attempts to configure NCQ priori=
ty
via sysfs using generic scripts or udev rules, it might fail for this drive=
r.

> +
> +The read-only attribute "sas_device_handle" represents the disk's device
> +handle, which is a unique identifier maintained by the firmware.

[ ... ]

> +4. poll_queues
> +--------------
> +
> +This parameter specifies the number of I/O queues to be used when operat=
ing
> +in io_uring poll mode. The default value is 0.
> +
> +File Location
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[Severity: Low]
Is a blank line missing after this section underline as well?

> +The driver source is located at:
> +
> +``drivers/scsi/leapraid/``

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785823793.gi=
t.doubled@leap-io-kernel.com?part=3D2
