Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794849422;
	b=43SdI1DPEt6ZGNtpAjS9H/EiavaGAsUyAdotk3gLNw3Jg/o4FjZqn7Rpl8csGUWHWnOU
	 XovAgnrjXU2Q7Uv01MjvFIyl0vuRviwUiygOiACfr1mIUh6NMxGWZz9FPkq9oBtHCCiog
	 g1iJlmAs9jXzOR3HjWU8XSniY6U92KVnzFplBmPAZt31rFD0Fl4Cjw6HdSglu/TAsv2rl
	 LoqnyKbNTCIKZSdctAGN5YbI89R27cGM6WCzDm4//a0CoUzXCzcqTBVg28BZQO4yiJ1Tb
	 Mcw2woOaTzfiPRUYFRq2NNn/zZtZuKIwo3VbcfOwvezAuqo/caMKdihPBJb75GZHzJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849422;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
	b=jXqcCIMmbvmODwjD2+RKkK648Y0C4qzoDBRBhR7atwBYLBB/tg7bu5bCP3sDlgCdyuQl
	 nB0C46Elp6CGt9HuYE9pwhK/GFWKvkh/W0NSfvBJ7Bp7H328USc41rXIj0EfuXiv2NMTX
	 TTD+Voj2udTwrgm3ZAA+HI/1I/eGOrStRHRSX5Ut4TPaJOf5PBiK31krUmUJcyCrQ78+i
	 OBPMKL6d4ZZ5X77eCOpvGWh0k854OhSDVviNMFVIrO9VO1qCSn8uTVNjfwYKFnAtcYRz3
	 NUZQH3YJrt9n5DUEwEZpC8JLH8bcenxN3iV30QcSSqi3dO01y9Lp6BlloH3bn3TklPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=muR038w6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8EA606A89B
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 17:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC8EA606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=muR038w6
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so5448127a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 09:16:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794849418; cv=none;
        d=google.com; s=arc-20260327;
        b=Zy5au8BFkLtbIarfqmdAuM8PVWrs4HYyEjnwtuswXMgpY3ZRh+clcSxu2xtB/mtzPj
         7eFSL0CUI00l8dNyo5FtelzO+nHT7PQ8eSJYMl3hEkPda7h8+mgL9ADghas80tfF/+PO
         6Fh7GjhoNi6N//1ACyenGfw0wtp+yzA3BZE2xqQW1oSPKG1mMMoJnJAi24x0Pt5cwqlj
         bXpVADYOhtRJRCrtZtzsi5oqgY17eoQrWgfn/qJrzXVmlNfDs57RLN0jTVz1emrnlsBl
         Iwqi4Q3yGDdO/LepNFPGtD73kRAKYyrhxd47BbD9IshwU3Fc6TE/6Rwfd3By35sizLPr
         woYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        fh=ECSMP2gtw+oBzQ7AoxYfBpuPMCKmgFbx2Gvi+oQeJi4=;
        b=owWTvvXKzxHcxhZJZkQuavRG3Zwjd0ONnK+HSAszPh/7ctDZ2ElRbO8iwiO0OgB/QY
         FgmD9/FD6ZODCgerofS9PGhOYYRanFljFE/Kud3ZkAuLkAMCwSIvDu58CQ6jnsD/rUha
         mt2kALfErkw74+STR2CnMrXz99pEJ1ZOFs/6nvBJPkc7+MtbjKoCvvA9LCC2W/LhLSPr
         mGGmzzhyKwH2d0rbGFHsdPrfiBSq7dR8fW+nTzHBxjJgThj/KIyvjAZWOJYIfDT/4DWj
         0eWNGHyxjegaItFE9gctTA/T+bS1xeTyliSCfyufvsV9PKuSaH/Rwgeu58IkUutWGj/A
         GGsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794849418; x=1795454218; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=muR038w65/upa4T3A8TQUgAZPPu00HSp8IEYxLeziP5g7EOqEdvXR4kRn7l7HqC4oM
         V/H7jmVddckf4li4Y0IfO1NYwf6mTpnVcEibSiDpSUGa4rmH8J48GG/AdleQHZhCXsRY
         RKMQZVymvxJl7k97IWLEoqvjx7NjiZbQg2uAM4mR3pJQKz5WqOab8nzYhREPb/6gAZ9i
         pBA6UOQY1B36uqzP1y0SScadwu/L0Druqoe1fQdOxwb3sdGBUZ1ThrB2CqjVL4+PzHGX
         wt9TbJGmNBshQby+yMN9+pQ2Lz5tWQc68vsAD3w5jK3lYbmvcjKJb74HqwwAi+/L+rlV
         RvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849418; x=1795454218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=OYRqixKM8oi/TlDYzyYCzHCGvGSGGISEnoXp0VpAN5FRZfnNPN5N8wbzY2ysGGOQCX
         c+kjGqECZ4DUvoGw5aJ5JyV/YkNfPyk6oyIYWcbdgOfxxE79ryaeXFSnRtLHfATtnu+P
         zrkWFnzFUp17BHI1rzdCAfa0C7xMXDs2mNoC+CIcPGXioK8vpIx4Udxa/lvldWyd5/5m
         ABx2CS6nlSQyMgXdhqAHnkRYFeqUyvJ7kZoE2AnHIVXR9CtYtvbCQfvnMzmYTBvG7RV3
         OLKa5jeUmj5zGoHk3zl0+qqmypBn9Q4HIzp0eRYY3pmHHyzoh594aKC0UnAZkE7Jz4cJ
         C8aQ==
X-Forwarded-Encrypted: i=1; AL+hErG/eW1UkQDw5HyXVyhgVP4br4YkHrPGZ/fkLpo602AQSuKUqEQ1YVvhs9rNv90XnN3gxVcgKWq175Ss@vger.kernel.org
X-Gm-Message-State: APuU4Z/5FqPoVkyf79Z2oQ9/1t0V8iqQ5kMjE9LJLsQpQ35UEzMXtrxj
	NlUST8B8ao7N5RENvZroeJDvR70QMRFNWjZPMSGIB2NyAG1XfjufmWPNP1bDVuCtTJdoDxFyNei
	yDvxmzyVb+FeYgHpcfVd4uaY2Iw42Qok=
X-Gm-Gg: AYBFou1EzxinePJNUYYjXvPxBJ1fk8ZktX2OzIuiUDCO8DloL815YSjvWRR5Nzey1fz
	RdICp0GJRRTa9/0F9DjAaa2O7pS4W0sgHCvZtbSDcz6lMl3UgPapWUES8Ww2STkkgWwPR93RW+1
	4N3F/AE65uiXU38pzEjdevaQ4HbGBBEZZHgjLWfu7bmgkKIKQ3Th1DG5z+BoG8rBc+cgrv10YJR
	1J4Jase3tG0GAj+ieJ64PiAalB4C2aDj8U4vna5uO01a1cXpUt2VdqLzjGEauXt5ZLmixNkqo0m
	lcw4zXzGRCZCnUhyif9dr5T1K9+kXM78Z8BijxHdGWrhhL0GQYpMTwiy0HNkdjaImV19CcLl0vp
	9nN2vTrOyYb9GoCTV69A8G/vok3BQx1aLipCifm0jSeMLnbNgEJAe28agEkExfVGtl+S/NRRPZn
	rB8JXkZr97kS4TFEA=
X-Received: by 2002:aa7:c258:0:b0:6b7:d69a:a3d3 with SMTP id
 4fb4d7f45d1cf-6b7d69aa8fbmr5089335a12.39.1794849418257; Mon, 16 Nov 2026
 09:16:58 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:16:46 +0100
X-Gm-Features: AclHuK_s2Kpb4OdbgPngYJl9gLHjfhlAmiJMqLtxRnpTDibz-Ni4SZJspSV9laM
Message-ID: <CAOQ4uxjJVgy-skUbbScfz=eAEATf=iMpqRHNshX=eKu3oiwnrA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 34/44] selftests/ovl: test data-only layers on
 pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Add tests that overlayfs refuses data-only layers on pseudo filesystems:
>
> - sysfs and procfs via the "::" separator in "lowerdir=3D"
> - sysfs and procfs via "datadir+" by path
> - sysfs and procfs via "datadir+" by file descriptor
> - tmpfs as data-only layer
> - sysfs as regular lower layer
>
> The last two must keep mounting.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  .../selftests/filesystems/overlayfs/.gitignore     |   1 +
>  .../selftests/filesystems/overlayfs/Makefile       |   1 +
>  .../filesystems/overlayfs/pseudo_datadir.c         | 131 +++++++++++++++=
++++++
>  3 files changed, 133 insertions(+)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/.gitignore b/t=
ools/testing/selftests/filesystems/overlayfs/.gitignore
> index b343cc430051d..e1410fee2269d 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/.gitignore
> +++ b/tools/testing/selftests/filesystems/overlayfs/.gitignore
> @@ -3,3 +3,4 @@ dev_in_maps
>  set_layers_via_fds
>  idmapped_mounts
>  automount_in_layer
> +pseudo_datadir
> diff --git a/tools/testing/selftests/filesystems/overlayfs/Makefile b/too=
ls/testing/selftests/filesystems/overlayfs/Makefile
> index 382a59bda5e70..ace75f5627e0f 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/Makefile
> +++ b/tools/testing/selftests/filesystems/overlayfs/Makefile
> @@ -10,6 +10,7 @@ TEST_GEN_PROGS :=3D dev_in_maps
>  TEST_GEN_PROGS +=3D set_layers_via_fds
>  TEST_GEN_PROGS +=3D idmapped_mounts
>  TEST_GEN_PROGS +=3D automount_in_layer
> +TEST_GEN_PROGS +=3D pseudo_datadir
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir=
.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> new file mode 100644
> index 0000000000000..3b59fd3e9f5c2
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include "kselftest_harness.h"
> +#include "../wrappers.h"
> +
> +static int setup_tmp(void)
> +{
> +       if (unshare(CLONE_NEWNS))
> +               return -errno;
> +       if (sys_mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
> +               return -errno;
> +       if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +               return -errno;
> +       if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
> +           mkdir("/tmp/merged", 0755))
> +               return -errno;
> +       return 0;
> +}
> +
> +/* Mount an overlayfs with the legacy "lowerdir=3D" option. */
> +static int mount_lowerdir(const char *lowerdir)
> +{
> +       char opts[256];
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s", lowerdir);
> +       if (sys_mount("overlay", "/tmp/merged", "overlay", MS_RDONLY, opt=
s))
> +               return -errno;
> +       if (umount2("/tmp/merged", 0))
> +               return -errno;
> +       return 0;
> +}
> +
> +static int set_layer(int fd_context, const char *key, const char *path,
> +                    bool by_fd)
> +{
> +       int fd, ret =3D 0;
> +
> +       if (!by_fd) {
> +               if (sys_fsconfig(fd_context, FSCONFIG_SET_STRING, key, pa=
th, 0))
> +                       return -errno;
> +               return 0;
> +       }
> +
> +       fd =3D open(path, O_DIRECTORY | O_CLOEXEC);
> +       if (fd < 0)
> +               return -errno;
> +       if (sys_fsconfig(fd_context, FSCONFIG_SET_FD, key, NULL, fd))
> +               ret =3D -errno;
> +       close(fd);
> +       return ret;
> +}
> +
> +/* Create an overlayfs with "lowerdir+" and "datadir+" through fsconfig.=
 */
> +static int fsmount_layers(const char *lower, const char *data, bool by_f=
d)
> +{
> +       int fd_context, fd_mnt, ret;
> +
> +       fd_context =3D sys_fsopen("overlay", FSOPEN_CLOEXEC);
> +       if (fd_context < 0)
> +               return -errno;
> +
> +       ret =3D set_layer(fd_context, "lowerdir+", lower, by_fd);
> +       if (ret)
> +               goto out;
> +       ret =3D set_layer(fd_context, "datadir+", data, by_fd);
> +       if (ret)
> +               goto out;
> +
> +       if (sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0))=
 {
> +               ret =3D -errno;
> +               goto out;
> +       }
> +
> +       fd_mnt =3D sys_fsmount(fd_context, FSMOUNT_CLOEXEC, 0);
> +       if (fd_mnt < 0)
> +               ret =3D -errno;
> +       else
> +               close(fd_mnt);
> +out:
> +       close(fd_context);
> +       return ret;
> +}
> +
> +TEST(datadir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/sys/kernel"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", false), -EI=
NVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", true), -EIN=
VAL);
> +}
> +
> +TEST(datadir_procfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/proc"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", false), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", true), -EINVAL);
> +}
> +
> +TEST(datadir_tmpfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
> +}
> +
> +TEST(lowerdir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel:/tmp/lower"), 0);
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", true), 0);
> +}
> +
> +TEST_HARNESS_MAIN
>
> --
> 2.53.0
>
