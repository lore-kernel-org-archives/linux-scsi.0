Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717314;
	b=WlEjmzMTt+xu6pDetutqL1PWtFUDxKJWn6oHjEZosWhGTrXj0T2Mo1Kybaa1qIQC0E90
	 fEmVwgLRhDSF+1dafwPS6n5xdM5DysH+NmuPMOEuFHx5L5J/YWYUI/Z3f2P3V9vgj/LoR
	 5EB46YPYaDcSGIFcpaG3mf6guyIYcARRoghDHHc07Sw1SR4GQmQU/kInCwMpxad67xiiq
	 UVFYf/dIhIGAHz9F8oIqQEgVhLWi8gskLVA8QDIvlEWU1Hablvwju5hivlr6o8uIO/egY
	 iV7BbJp652jHkUmqOoLWsceQ/CBUZb+aLZHZ4B5xkZCZOCYtPNJyeK3wt7d//I4rtOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717314;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Y+bptWnMsm9688ffvlZik5wuheu2AuAp4FHdf42AsHs=;
	b=wC6IvMfQV5RerNdaMPdPg0WOHIVUEvtxATgcMJC9/BHM5lneA+Ym9YyeKVJ9l4qkGN/U
	 fB7iLpB68gFxhK2y1glsWjBqaVwA8LCfocNPpUXWxCOi3lPm5qoziDSRJtkVEzRsRi1yz
	 bDEHR9IX5RJSllMZRR/kb5q8lzh8OdodvXgA6NmNNqYLpttzUQeB4vGQA1AULdXuSKDbM
	 HQsdNaaOJRq06ubEIqtQbWxvyEB/Z3Ro6iMEfvzLu5MrxekA1ursj9N7m13BpMmOaaPoU
	 jnyOcmj+o/doBwv3KAarG3Xpjw9qjnLYzcdPYETZydTrR8UuTPABLOWKnOVAnXplcDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I1YHc/Mt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA6C606BA27;
	Tue,  3 Nov 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I1YHc/Mt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C941F000C1;
	Tue,  3 Nov 2026 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717313;
	bh=Y+bptWnMsm9688ffvlZik5wuheu2AuAp4FHdf42AsHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I1YHc/MtZN8GDa7UIDwX7EZbAGqySvUQ9iJMmqHpFghXtS1a7u1snUSRoQZbPgotf
	 rzTS20EjRbQSiraVWbKDq4ZCE++cNFCKRi5Aaifb5wigRVmBCmMaDT7YdKMsDB9tDI
	 EKZhwJ8mtHIR7tJTtUGX8l08CJRlHDCymC+ysWL+tDYTrAJTPYswbt5itzEnPuNwmU
	 0VvXfu6Z2XZnOqblVvT6wHfP6+iohenxq+H4qRRnC04rlzIf4Onp6n05i56McAI+1Y
	 TqDE/PH+7Hpp+X7zYzUT3YtEtnTjOTA8j+Z92u2V2zFKtu1xuQnbMQURmWoACjuOYC
	 jjzKWAkws/G0g==
Message-ID: <sashiko-outbox-195504@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 32/38] selftests/proc: check a sysctl listing while
 entries come and go
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:31 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/proc: missing prerequisite skips in sysctl_readdir_set=
up()
- [Low] selftests/proc: proc-sysctl-readdir-churn duplicates proc-readdir-c=
hurn
--

commit 9b75f87bfb2fb1adbf5b6ac83f3bfdac725df7f5
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check a sysctl listing while entries come and go

This commit adds a new kselftest binary, proc-sysctl-readdir-churn, to veri=
fy
that multi-call getdents64() listings of /proc/sys/net/ipv4/conf do not rep=
eat
or skip entries when a tun network device is registered or unregistered
between calls.

> diff --git a/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c b/t=
ools/testing/selftests/proc/proc-sysctl-readdir-churn.c
> new file mode 100644
> index 0000000000000..0e067a3619c44
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
> @@ -0,0 +1,147 @@

[ ... ]

> +#define CONF_DIR	"/proc/sys/net/ipv4/conf"
> +#define TUN_NAME	"a0"		/* sorts before "all" */
> +#define TUN_PATH	CONF_DIR "/" TUN_NAME
> +#define SMALL_BUF	80		/* ".", ".." and one short name */
> +#define NAMES		64
> +
> +static int tun_open(const char *name)
> +{
> +	struct ifreq ifr =3D {};
> +	int fd;
> +
> +	fd =3D open("/dev/net/tun", O_RDWR | O_CLOEXEC);
> +	if (fd < 0)
> +		return -1;
> +	strncpy(ifr.ifr_name, name, IFNAMSIZ - 1);
> +	ifr.ifr_flags =3D IFF_TUN | IFF_NO_PI;
> +	if (ioctl(fd, TUNSETIFF, &ifr)) {
> +		close(fd);
> +		return -1;
> +	}
> +	return fd;
> +}
> +
> +/* one getdents64() into @buf, the names appended to @names */
> +static int list(int fd, char *buf, size_t size, char names[][NAME_MAX + =
1],
> +		int *n)
> +{
> +	long ret, off;
> +	int got =3D 0;
> +
> +	ret =3D syscall(__NR_getdents64, fd, buf, size);
> +	if (ret < 0)
> +		return -errno;
> +	for (off =3D 0; off < ret;) {
> +		struct dirent64 *d =3D (void *)(buf + off);
> +
> +		if (*n < NAMES)
> +			strcpy(names[(*n)++], d->d_name);
> +		got++;
> +		off +=3D d->d_reclen;
> +	}
> +	return got;
> +}
> +
> +static int count(char names[][NAME_MAX + 1], int n, const char *name)
> +{
> +	int i, c =3D 0;
> +
> +	for (i =3D 0; i < n; i++)
> +		if (!strcmp(names[i], name))
> +			c++;
> +	return c;
> +}
> +
> +FIXTURE(sysctl_readdir) {
> +	int dir;
> +	int n;
> +	char names[NAMES][NAME_MAX + 1];
> +	char buf[65536];
> +};

[Severity: Low]
This isn't a bug, but tun_open(), list(), count(), the fixture state in
FIXTURE(sysctl_readdir), and the register_in_front and unregister_in_front
test flows in tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
duplicate the helpers, FIXTURE(proc_readdir), and the add_in_front and
remove_in_front test cases in tools/testing/selftests/proc/proc-readdir-chu=
rn.c,
differing only in the target directory (/proc/sys/net/ipv4/conf vs
/proc/net/dev_snmp6) and expected baseline entries (all, default, and lo vs
lo).

Could this be parameterized in proc-readdir-churn.c using FIXTURE_VARIANT a=
nd
FIXTURE_VARIANT_ADD instead of introducing a second standalone test file wi=
th
duplicated helpers and test logic?

> +
> +FIXTURE_SETUP(sysctl_readdir)
> +{
> +	if (unshare(CLONE_NEWNET))
> +		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
> +	if (access("/dev/net/tun", F_OK))
> +		SKIP(return, "/dev/net/tun: %s", strerror(errno));
> +	self->dir =3D open(CONF_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
> +	ASSERT_GE(self->dir, 0);
> +	self->n =3D 0;
> +}
> +
> +FIXTURE_TEARDOWN(sysctl_readdir)
> +{
> +	close(self->dir);
> +}
> +
> +/* a device registered in front of the position doesn't repeat an entry =
*/
> +TEST_F(sysctl_readdir, register_in_front)
> +{
> +	int tun;
> +
> +	/* ".", ".." and "all", "default" doesn't fit */
> +	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n),=
 3);
> +	ASSERT_EQ(count(self->names, self->n, "all"), 1);
> +
> +	tun =3D tun_open(TUN_NAME);
> +	ASSERT_GE(tun, 0);

[Severity: Medium]
In FIXTURE_SETUP(sysctl_readdir), opening CONF_DIR (/proc/sys/net/ipv4/conf)
is checked with ASSERT_GE(self->dir, 0), whereas proc-readdir-churn.c skips
when opening SNMP6_DIR fails:

tools/testing/selftests/proc/proc-readdir-churn.c:FIXTURE_SETUP(proc_readdi=
r) {
	...
	self->dir =3D open(SNMP6_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
	if (self->dir < 0)
		SKIP(return, SNMP6_DIR ": %s", strerror(errno));
}

In addition, FIXTURE_SETUP(sysctl_readdir) only checks
access("/dev/net/tun", F_OK). On systems where /dev/net/tun exists as a
static device node (for example, created by udev or kmod static-nodes) while
CONFIG_TUN is disabled, access("/dev/net/tun", F_OK) succeeds, but
open("/dev/net/tun", ...) inside tun_open(TUN_NAME) fails with ENODEV or
ENXIO and triggers ASSERT_GE(tun, 0) in register_in_front and
unregister_in_front.

Since tools/testing/selftests/proc/config only enables CONFIG_PROC_FS=3Dy at
this point, will running this test on a kernel without CONFIG_SYSCTL,
CONFIG_INET, or CONFIG_TUN fail the test instead of skipping when those
prerequisites are unavailable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D32
