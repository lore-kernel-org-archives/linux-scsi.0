Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789503;
	b=E8jgILzwnHxc5vGX5yGHQC84H81O3wBfjxPagRMrkY25LXrjqa+HFRTLAp7Ef4Af3zqk
	 DHb6oWrvJMaV6f/rWJzeGVqZgvokNY788aSElQ+SeFPVei5nVKb0dKCThVfFDXtRhR5Wo
	 zP72/yrk1LxZwcuMQB8adaLEAFShfNuMT/pbIzgLmkmngKr31bhlNkgD4tGOEIwFWXxgp
	 cKkT0DxwO3NvRT0F1NcS55qUCYJh1C29cNsedc4HHIAo8gOzEOWJCH7o8IIVpja3miHT9
	 Fxe5OtmZFnaJlj6uN6sU3KFNxHjEQWMCajx1/UoY8aHKXCQVFCw9PfzsaamvHcNX4sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789503;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KFy67eT3nSAp9PsHhnFoIkIIbEJ9g0vy8fOzWHKAy/U=;
	b=VqrmmYhYPwEWRYf55wpGSgdpgS3yREmDGikQ9HbSnqiAoQgPsvt7eI3ihKO49uGus3g8
	 Pz5VXPQg4PIaofVwDB+v0lkZDtn5slaHD8duY+Jo+7s47/e6i+TyuhJ2e0lsbyWT7tGw8
	 +i2vZ7tpkGOJLivQIXzQ6/PUezCo2SmaF7hgLh4xX0hq8Eawh4NX/OzKUDNH+m4Ly8GZQ
	 m/Ra0XkXHXnrscQ/XkCHdhlKizdg/l8J9I8QAnDpFvMMlPDgjnjrYWgC+dks0TByIH3H4
	 FzwvfGIno6l/EyKeKdnKBYvbBoMbqKhTZF6qOMN8SnTg23UDd6+KIMHWbMjz6Xydj+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JNJ8dCf4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABF6606A32C;
	Mon, 16 Nov 2026 00:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JNJ8dCf4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F19C1F000C4;
	Mon, 16 Nov 2026 00:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789502;
	bh=KFy67eT3nSAp9PsHhnFoIkIIbEJ9g0vy8fOzWHKAy/U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JNJ8dCf45Kzitzo2KEWwF0qEepHaLjG86OqcfN5MqnXI/hN+/3bRZvCicYdzxkYO/
	 NLb3m52ZzErk7cU5iX1gvI70/xCjXwpLIu952W6sJnHuZrq7WA7r/Gq0j+67DehBmt
	 10N8r0RTDbZmlhD00/BSeRIXWTEu+5hKI4WgwLynKkvOgs1xT1dc+oR3lC4iBLsxO7
	 MLZTX+2hrt7IS0FA7cc2gAOZRFC8KtwRN9k8aj5opO9y3hkJ7Mn7b8wNJZjreZp5gF
	 96DiLr87hJImEBdPWihenMiNzowECUftpXQ6/11b3raiGBcLihSocoHrfx1VgSxMIR
	 bcGL7imTHwpXA==
Message-ID: <sashiko-outbox-215959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 01/18] scsi: target: uring: Introduce an io_uring
 based user backstore
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-1-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-1-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:38:22 +0000
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
- [Medium] scsi: target: missing target_core_uring autoload in
  transport_subsystem_check_init()
- [Medium] scsi: target: uring: block_size desync and underflow in
  tcmur_get_blocks()
--

commit 61188ead36f715e3a08be0d083f957ddb97dafd3
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Introduce an io_uring based user backstore

This commit adds the initial target_core_uring LIO backstore plugin with
configfs support for configuring device size and block size, and emulates
SCSI commands via sbc_parse_cdb().

> diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> index 92641d39126a3..545a1d4cf37e5 100644
> --- a/drivers/target/Kconfig
> +++ b/drivers/target/Kconfig
> @@ -43,6 +43,16 @@ config TCM_USER2
>  	process to handle requests. This is version 2 of the ABI; version 1
>  	is obsolete.
> =20
> +config TCM_URING
> +	tristate "TCM/URING Subsystem Plugin for Linux"
> +	depends on IO_URING
> +	help
> +	  Say Y here to enable the TCM/URING subsystem plugin, which lets a
> +	  userspace server handle the block commands of a device through
> +	  io_uring commands. Unlike TCM/USER, the kernel emulates the SCSI
> +	  commands and the server only reads, writes, flushes and unmaps
> +	  blocks, on several queues and without copying data twice.
> +

[Severity: Medium]
Should transport_subsystem_check_init() also autoload target_core_uring
when CONFIG_TCM_URING=3Dm?

When creating an HBA directory in configfs, target_core_call_addhbatotarget=
()
calls transport_subsystem_check_init(), which autoloads the other modular
backstores (target_core_iblock, target_core_file, target_core_pscsi, and
target_core_user) via request_module() before core_alloc_hba() searches
backend_list.  Without an entry for target_core_uring, creating a uring_<id>
HBA in configfs fails with -EINVAL unless the module was loaded manually
beforehand.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> new file mode 100644
> index 0000000000000..13981e608a85c
> --- /dev/null
> +++ b/drivers/target/target_core_uring.c
[ ... ]
> +		switch (token) {
> +		case Opt_block_size:
> +			if (val < 512 || val > PAGE_SIZE || !is_power_of_2(val))
> +				ret =3D -EINVAL;
> +			else
> +				udev->block_size =3D val;
> +			break;
> +		}
> +	}
> +
> +	kfree(orig);
> +	return ret ? ret : count;
> +}
> +
> +static ssize_t tcmur_show_configfs_dev_params(struct se_device *dev, cha=
r *b)
> +{
> +	struct tcmur_dev *udev =3D TCMUR_DEV(dev);
> +	ssize_t bl =3D 0;
> +
> +	bl +=3D sprintf(b + bl, "Size: %llu Block size: %u", udev->dev_size,
> +		      udev->block_size);
> +	bl +=3D sprintf(b + bl, "\n");
> +	return bl;
> +}
> +
> +static sector_t tcmur_get_blocks(struct se_device *dev)
> +{
> +	struct tcmur_dev *udev =3D TCMUR_DEV(dev);
> +
> +	return div_u64(udev->dev_size, dev->dev_attrib.block_size) - 1;
> +}

[Severity: Medium]
Can tcmur_get_blocks() underflow to ULLONG_MAX and leave udev->block_size
out of sync when attrib/block_size is modified after device configuration?

Because tcmur_ops sets tb_dev_attrib_attrs =3D sbc_attrib_attrs, userspace
can write to attrib/block_size after target_configure_device() has run.
block_size_store() updates dev->dev_attrib.block_size without updating
udev->block_size or revalidating udev->dev_size.  If a device is configured
with dev_size=3D512 and block_size=3D512 and attrib/block_size is then set =
to
4096, div_u64(udev->dev_size, dev->dev_attrib.block_size) returns 0 and
tcmur_get_blocks() wraps to ULLONG_MAX, wrapping end_lba to 0 in
sbc_parse_cdb() and reporting 0xffffffffffffffff blocks in
READ CAPACITY (16).

Also, Opt_block_size accepts powers of two up to PAGE_SIZE, which on 16K or
64K page kernels permits block sizes above 4096 that LIO core does not
support in block_size_store() or target_to_linux_sector().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D1
