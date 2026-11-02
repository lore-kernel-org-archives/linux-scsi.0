Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631101;
	b=4HadV6Tthj974mXaOEhGr7GDBFo5qB+hrv9enxL1gxjpLcsAV0I9cVbU1Qwj0YYbYhXf
	 uNud3YF4mFMXKqdgYM5SLehFky+E6F5J1d/UAwJ8535SdpGYvomwgEH8IV0Bunh3idCw7
	 7vB8+4CZwixW4aRT5Ejyu0qXewP3/vnTxfTeqJyBxQP3JAjYOIyLNoYg6ruW7Gvg3upUR
	 WgyImVyd6WCgK+eOGXVZ9N8Zun3bjfyBaI1WiYbON085vVa6zCoefPiN2DJGH22lQzYDA
	 C+93WQa/I3mvrQHzivjwFlxUYaFw56MStf/IbNC4B5ynWVkm2NaVWaaJQRicAnKHVxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631101;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3PMBNHbf4ph/mdyR65c545+LMS26XozggfD62W0AADg=;
	b=evmYpX9OfEpQuvyEOSzA0ei0MB8TRP+1fYY4rWUlpYdAB4l2/WGn8pl3TWM7Rka6QsrE
	 V7EABBYPrWZs4B5p5Q8rp72ndZ50oVLO9atneA3Se6wKiK7Ciw5OcGvVpqByuz/C28jqS
	 aDmCpcBET55dr/DvgzOApkLUtdMIp5UpgDTXDx9Ll23nkPhaLesjQxWPU2PIa3Dg8QZrL
	 qSvTNW9y3gQqtth+Y4wEbfY6GufPH1tG05A8wkdW3yMZ7XjsO7gPej+2zHkSn6EMQ9UC6
	 zu08UX4nznX6PJG9YrOuP9mh/Oq6YhGn2HOrJG7W7WfuRoDB4PvPT5WjY8+0+RNH7lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GlNn/SoM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7676076D8D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GlNn/SoM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2681F0157D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631100;
	bh=3PMBNHbf4ph/mdyR65c545+LMS26XozggfD62W0AADg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GlNn/SoMWD5zqxxqX/eCuEquiTNPRgmYC+uyTlQFZ16kexqk/KmCRp3INGj7ss8oQ
	 VUu1KkbtGSGsG3pM3YZ4MDiwbG5YrkBKBiN14T/X9emJ88g5DPj3pIXVn3phJmyVow
	 KX2JEr2f7UDK3U8ijM+CbxeE6tC6vIkI/nKJYJzvIxjwONjYrUXdb0ed56rsLZ06JR
	 rdYISyB5bt/rhPIvfR1HgK23GVD6ypB685bMRxWVtqNBK0a9B3nWL37+brdRtxbv2s
	 OHz5HfLYY/uUgJVHbpI/TT4TXRUNjrxgB4dmkRp6j56kdwhka9W+cvSiBS0wLtgATL
	 65EIv4d24CLeA==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so1862945e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 06:51:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz7q4x0rjPXOWKKr5a+D5Hg/b0nR8inDE8KizcmT+XXgRET7v5kpnEq1SbhomMysGMm8aVW58+Q+dw3@vger.kernel.org
X-Gm-Message-State: APuU4Z9uZgLyf01RABO1BR2mJuUzzzHyRMhC9OiLGfCEWd1mBq7djqet
	E4kUx5+p4+uIVTT8rf80KxMEhiDtVQ3JiZ2CFLgQ+DKn49sPRbjBQ0BBXmv0BCi5ZZovCkVClLe
	uz2ALGmxfLU+jf1J7rA9RNuL6svQj1f4=
X-Received: by 2002:a05:6512:39cf:b0:5bc:b0b9:f457 with SMTP id
 2adb3069b0e04-5bfd95827e8mr3755837e87.47.1793631098488; Mon, 02 Nov 2026
 06:51:38 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Mon, 2 Nov 2026 15:51:25 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gw6xykAX3dvJmjhVOQudF8qKgKLViY0oXGzUWqDsWDbg@mail.gmail.com>
X-Gm-Features: AclHuK-8h3kqhIhfKB_FBrHc69T85DQwOpvSG7VveYTuGyJayTx7vBef-7fYqkY
Message-ID: <CAJZ5v0gw6xykAX3dvJmjhVOQudF8qKgKLViY0oXGzUWqDsWDbg@mail.gmail.com>
Subject: Re: [PATCH RFC 02/38] PNP: isapnp: don't read past the end of the
 buffer on a large pread()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:22=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> isapnp_proc_bus_read() truncates the position to an int. A pread() at
> an offset like 0xfffffc00 turns it negative, the check against the size
> of the configuration space passes, and the loop then puts everything
> from that position up to byte 256 into the reader's buffer, no matter
> how few bytes were asked for.
>
> Keep the position as a loff_t and clamp the count against what is left
> of the configuration space.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

> ---
>  drivers/pnp/isapnp/proc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
> index c1f6e6bd0eb2..8197c7f29743 100644
> --- a/drivers/pnp/isapnp/proc.c
> +++ b/drivers/pnp/isapnp/proc.c
> @@ -23,14 +23,12 @@ static ssize_t isapnp_proc_bus_read(struct file *file=
, char __user * buf,
>                                     size_t nbytes, loff_t * ppos)
>  {
>         struct pnp_dev *dev =3D pde_data(file_inode(file));
> -       int pos =3D *ppos;
> +       loff_t pos =3D *ppos;
>         int cnt, size =3D 256;
>
>         if (pos >=3D size)
>                 return 0;
> -       if (nbytes >=3D size)
> -               nbytes =3D size;
> -       if (pos + nbytes > size)
> +       if (nbytes > size - pos)
>                 nbytes =3D size - pos;
>         cnt =3D nbytes;
>
>
> --
> 2.53.0
>
>
