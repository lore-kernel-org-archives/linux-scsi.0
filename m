Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828509;
	b=4izs2+urQhyfXGllBeRMI1Yp2GicoTNWRFilGtkB8LxWrJzF8Vw1INThxKtw9KL4yg8b
	 YiVAB5fSkmymMjrXl26s7kRdjpPC26IXctdE+0JII0MtIjk+XCXIati+TktMLlSqQW7to
	 kX/PI4T5s1I6oaeQzH0hvhpxAby17vZh52MAXRUAT4rsqi4lxgE7NrrF1JjvGaENg9ZXJ
	 1EybDRox78WYU/hGOWMtjD0Dfv4JbQ2WPn3nj9AIVye227TMIhGIU3kGIWTG4EjZB4M1Z
	 oSiSaKjZTYndY91M1qDKqnq0BCzRmvN3pzAgbb9kA7lfbW8pn0oiRfdogjHUX5pGomw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828509;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RW3Nmjz+GbO91KVwbZw20axMMPWohpmxD8TXxvGg3/8=;
	b=hnBvGu03zSiAs81by2ANpHZb19jv+DUGMP/aIl6YaFAgnWPz0wpMhoEhLjyZRDxv9NAZ
	 XlKjsgifWFW3b2BHeKmBMojKktnpZhcLXq/f9AZW7e2i19lxrO5sIJDEPH5cY/E/D31+a
	 DoR41klwLrJqFNLOL140H8Qk8Gsrc/gU/viJQOtJRMK7uc2aMWBUA/yJZxINMrI+za1bL
	 0/k4qPcWbmGPAabWMTLSJxQ5H5wMQu3atMziHAUyUbnUXCvFg2OJpjRiAuD6am94HObBc
	 VXmEYB0AxIZ/cuZxIU+O0wHDQSKFqSVKsVrTQxFn54q1VaVt28YOwQElVyvUH35w6kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dgaswur9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D6F606A330;
	Mon, 16 Nov 2026 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dgaswur9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E091F000C4;
	Mon, 16 Nov 2026 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828508;
	bh=RW3Nmjz+GbO91KVwbZw20axMMPWohpmxD8TXxvGg3/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dgaswur9NKmVb2Cj2LBZvzzO++YPkgo2pM4LudFKJRS+BkMI5ErMhhAJqeDzhVlDv
	 eCPlnjvzIK+Il93Dk6xH3UrLaJjZsGk3GL/xs8+hSbIxs45r7o6sNqCn1GqDoq24qq
	 2QUS9uyBVKqILqww7albcp/nEZC5F+Gxqn2u6w+1S/QSyjVgBvEMBaBvy8oC1WrTZV
	 rcnaX+dbnp5rdl8gyPjgXF2DkHTYsV59wdAhIGeMurQ7N8u+SHTHNYNZNVuKeBPD4z
	 5O24la+RsvuF8Pvvu97OG2nsodEcHs5Rzt5fUjwVYjICfJDOyrd8HrYrpVXTeV62Oy
	 fIYgTSktA3yuQ==
Message-ID: <sashiko-outbox-216927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 34/44] selftests/ovl: test data-only layers on
 pseudo filesystems
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>, "Josef
 Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>, linux-nvme@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, linux-efi@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Amir
 Goldstein" <amir73il@gmail.com>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
 <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 11:28:27 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] selftests/ovl: missing prerequisite skips in setup_tmp() and
  tests
- [Low] selftests/ovl: duplicated setup_tmp() and datadir test cases
--

commit 9dfbd53c60eeeb8dceed3a46417fda9ee76bb58b
Author: Christian Brauner <brauner@kernel.org>

selftests/ovl: test data-only layers on pseudo filesystems

This commit adds an overlayfs selftest verifying that data-only layers on
pseudo filesystems (sysfs and procfs) are rejected while tmpfs data-only
layers and sysfs lower layers remain allowed.

> diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir=
.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> new file mode 100644
> index 0000000000000..3b59fd3e9f5c2
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> @@ -0,0 +1,131 @@
[ ... ]
> +static int setup_tmp(void)
> +{
> +	if (unshare(CLONE_NEWNS))
> +		return -errno;
> +	if (sys_mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
> +		return -errno;
> +	if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +		return -errno;
> +	if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
> +	    mkdir("/tmp/merged", 0755))
> +		return -errno;
> +	return 0;
> +}

[Severity: Low]
Should these tests invoke SKIP() with a reason string when root privileges
or kernel overlayfs support are unavailable?

Running this test without root privileges causes setup_tmp() to fail with
-EPERM on unshare(CLONE_NEWNS), and running on a kernel without
CONFIG_OVERLAY_FS causes mount_lowerdir() and fsmount_layers() to return
-ENODEV, failing all four tests in make run_tests instead of skipping them.

[ ... ]

> +TEST(datadir_sysfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);
> +
> +	EXPECT_EQ(mount_lowerdir("/tmp/lower::/sys/kernel"), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", false), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", true), -EINVAL);
> +}
> +
> +TEST(datadir_procfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);
> +
> +	EXPECT_EQ(mount_lowerdir("/tmp/lower::/proc"), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", false), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", true), -EINVAL);
> +}
> +
> +TEST(datadir_tmpfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);
> +
> +	EXPECT_EQ(mount_lowerdir("/tmp/lower::/tmp/data"), 0);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", false), 0);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
> +}
> +
> +TEST(lowerdir_sysfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);

[Severity: Low]
This isn't a bug, but could setup_tmp() move into a FIXTURE_SETUP() block,
and could the three datadir_* tests be parameterized with FIXTURE_VARIANT()
over the path and expected return code to avoid duplicating the setup and
mount sequence?  Also, since set_layers_via_fds.c already tests lowerdir+
and datadir+ layer configuration, should these cases live there instead of
in a new standalone binary?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-loop-=
pseudo-v3-0-8cbbea1cf34f@kernel.org?part=3D34
