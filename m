Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717328;
	b=YKq8F8eGgkE4SPPyqC5MUzzA4kU2fibYbAMn0q2s1AmmD9Ls4bUS66Gi75m4HIxwul5e
	 cVScxEYOjPkejdVrtd1K5LGhOZg0f3Lt/OvO9T50tEGo8DXw/hREsKtJXWtf6EDNXCByx
	 R6pypfZ+6d+83G5CV/fY+ciHdlyJpXlG2xbNGsrR1eEfsGPaqehS8+bTLhxBEhaoHmu7G
	 ZgKAJFQVtINxHXQyz0WwksmMcpSN/IRVsW2WtDJK53UN4Quyu5IRH5hyWCnvWu12SxHGb
	 n56KpkHyDwZP/3MLaYIhgt+k+ySwe05x9tHJSfL6o+J0IpeK+Tz+EMbI9KvHIMeJUrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717328;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0V+CicgMBoN1QbZ4PU2bDKMr8pvOiaSaM7EPJ1DfD7w=;
	b=TKRn4Y29sJiC6brl3oq5/6JqNdBuAslN029+hxm6A6I/x1A+TmpKqesXLexACBSw9BNQ
	 hST9zAI04KB5bJUkJMz+JBv6UibDIeVvYFQFUY0faltNkvDDJg3sZYBztvw+BRx7vd+q8
	 4ZTE2l1YVCsh60nnL5YeSvuQGCyxT+aTSkVoAILBfdrVIrYx0lGokLjc4NesvMTQiU9jQ
	 9NDZm6VOPARznBoym96grt3SwJV2lz+m0QnTlP11zq0AQg5KZdZqhBB83dmBk4mAj9WSA
	 TUCmn0UlXCiFIlh8yFl1Ew3r7rrECZ8LbhXa7NKw8FPtqZYQ2AMy/+MUOkLf11o9TxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVuIrc17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25DE606D2D7;
	Tue,  3 Nov 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVuIrc17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0571F00919;
	Tue,  3 Nov 2026 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717327;
	bh=0V+CicgMBoN1QbZ4PU2bDKMr8pvOiaSaM7EPJ1DfD7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PVuIrc17XR1DR65SazgbGfICE7wjxOzqZgkY9U1rqo2UnB6kZRbNYqycjDbOYBHPI
	 mtr+oI337If1hGZt23auaywjb3aFf3e8V7x2KLacnHZWCqxTNAHGtZLRjV/QTQa/U0
	 2ZVG3QOmYYo3Vbue///pzGjX2fvcEVYSv1E5A4Nokf1yW93VnBHjLJNY9R0S7cKzna
	 lEsPjbqB4XU52YaxjHh1FMLVvCbZQad8DMHktuK95ryZyb144WX0kMVeswfQ7MIXWT
	 q6wVkMNqoNp3Q2h44ir/sz5Pqydvc1rrrcEksxS0NSkW2lL6OZFvuNnmSZDzSaqv1o
	 ng7I2nNH/acPg==
Message-ID: <sashiko-outbox-195510@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 38/38] selftests/proc: check that a faulting
 readlink() doesn't hold up removal
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:45 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/proc: Makefile adds nonexistent proc-remove-slow-reade=
r target
--

commit ac0073c08526e8690efa58576485d79bbd906522
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that a faulting readlink() doesn't hold up removal

This commit adds a selftest verifying that a readlink() call faulting via
userfaultfd on /proc/asound/<id> does not block removal of the /proc symlink
when renaming a dummy sound card.

> diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/self=
tests/proc/.gitignore
> index 7b81334927820..e2566cc0ae079 100644
> --- a/tools/testing/selftests/proc/.gitignore
> +++ b/tools/testing/selftests/proc/.gitignore
> @@ -22,6 +22,8 @@
>  /proc-uptime-002
>  /proc-pidns
>  /proc-remove-slow-sysctl
> +/proc-remove-slow-reader
> +/proc-remove-slow-readlink
>  /read
>  /self
>  /setns-dcache
> diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selfte=
sts/proc/Makefile
> index bce6beca72744..6a9bdc999f545 100644
> --- a/tools/testing/selftests/proc/Makefile
> +++ b/tools/testing/selftests/proc/Makefile
> @@ -33,5 +33,7 @@ TEST_GEN_PROGS +=3D proc-fsconfig-hidepid
>  TEST_GEN_PROGS +=3D proc-sysctl-readdir-churn
>  TEST_GEN_PROGS +=3D proc-pidns
>  TEST_GEN_PROGS +=3D proc-remove-slow-sysctl
> +TEST_GEN_PROGS +=3D proc-remove-slow-reader

[Severity: Medium]
Was proc-remove-slow-reader added to TEST_GEN_PROGS in
tools/testing/selftests/proc/Makefile (and to
tools/testing/selftests/proc/.gitignore) by mistake?

This patch adds tools/testing/selftests/proc/proc-remove-slow-readlink.c, b=
ut
tools/testing/selftests/proc/proc-remove-slow-reader.c does not exist in the
tree. Because the default all target in tools/testing/selftests/lib.mk depe=
nds
on $(TEST_GEN_PROGS), building the proc selftests fails with no rule to make
target proc-remove-slow-reader.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D38
