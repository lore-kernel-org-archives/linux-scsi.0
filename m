Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794231019;
	b=FjVbbc6DW4QLeLSqyGXRhWGqwHht61JWv20AOvSGThIZcsMoqICjh9ZwgkcTMB5w6dDL
	 pV6F1Fd5+AbjiKFX6qkmgV69VqcrRczXTBUlTUAx7UtYEFZJXNabGJpXx2UxrNemORBny
	 RjzIugCjXQDC8OdpY5fdRkfBdeVt9octrKqWBDMDP949i5goM+2TpCFZMWEOp/D34nyKO
	 2EdHzg1JhNuRoP1CXPRw6VS4koKVY9pAwJbnhW0iCUpDDLF4MI+Lg2kUQQ9HhI96+3ws+
	 jpMyol6PZ/NyLvQiOQ4X5pDdFH41ajtIQ3kX4Uw87iDoQvwetOxgkzMucmIHD5s6e1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4AjcU1FUDctPdLuxyd6QfNQ2IjyX6psvc9JdDRSfm+o=;
	b=lIxlY0iM5wl6t9dFjZ/uXqKHVvhx28hOCW2DtYk8kdHuiRKu6Cic1dV1u2oClWlul/Gb
	 ueetpHqvYD/sKEUqwL5SApKLa+uKLvSN9ptr3N5fTJEIHjaOEe9OVIKaNsk4wka9z5Waf
	 n5u2x3iC8iQfECrLq1YOeKmjr7R2mvIQi8ZMP+OOFgp1xyph330F7PtjDVpbeZfqSSlYh
	 vhRKtIPE6mVS0jImybOno01Cr+m8RnyIbh98IpBewbaSuYNzz2MmjlI7HyTuFudntTiSq
	 gvCy9inrA4onebTbeOiV7pY1aDWDbE51qUMRPbpGJBUp1PsCZxL4J9vAbF+bdQ77Cdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0XIu05+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D59606A322;
	Mon,  9 Nov 2026 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0XIu05+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B13A1F008A1;
	Mon,  9 Nov 2026 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231018;
	bh=4AjcU1FUDctPdLuxyd6QfNQ2IjyX6psvc9JdDRSfm+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b0XIu05+lUG8jnPVDff1Va7xAfNAQqzBTV94L6hXO9bEEDc54jiktEhwN29sg5bRy
	 Ncmx8ckaKcKnGQ8WlyIduHZJfxtoc/quFHraLgG7VvLyig40KUMZ7Z7PHpk4049E6u
	 KqmtFKoRoJx5k4OLhO7vu8YxHuUIBQ5CuSe4LPiL3clVgRipnrYvvYnLUtyMADsBoA
	 Xdp+lUzNp0g10WnppLmdtE31Opqx83u4rsNcoAMKghmQGmyC4wUzwu4FvtRyC5hxLF
	 0/qShefdahzGnkg7OA3XRm6RC1A3D7ulcMLXJDlYC7BjzKAgR7rK+a0NYn9tsVA0FJ
	 tgoC5kZnpMu0w==
Message-ID: <sashiko-outbox-205011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: compare all six ISID bytes when
 identifying a nexus
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ciro Iriarte" <ciro.iriarte+software@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <591ac67a-fa1e-4395-9573-2d9405cfe0b6@gmail.com>
References: <591ac67a-fa1e-4395-9573-2d9405cfe0b6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 13:30:17 +0000
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
- [High] scsi: target: core_scsi3_pr_seq_non_holder() rejects registered
  sessions
- [Low] scsi: target: inaccurate Fixes trailer for target_isid_to_bin()
  changes
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] scsi: target: unlocked list insertion in
  core_scsi3_alloc_aptpl_registration() [1]
--

commit 3cb145890f871c3538fab6da7b3f3187cbc5c48e
Author: Ciro Iriarte <ciro.iriarte+software@gmail.com>

> scsi: target: compare all six ISID bytes when identifying a nexus
>
> lio_sess_get_initiator_sid() reports the ISID as twelve hex digits, and
> iSCSI TransportIDs carry the same digits. __transport_register_session(),
> __core_scsi3_do_alloc_registration() and
> core_scsi3_alloc_aptpl_registration() turn that text into
> sess_bin_isid and pr_reg_bin_isid with get_unaligned_be64(), which takes
> the first eight characters, i.e. the first four ISID bytes.
>
> open-iscsi ISIDs start with 00023d00 and differ only in the qualifier in
> the last two bytes, so every session of one initiator gets the same
> binary ISID. target_scsi2_reservation_check() and
> target_scsi3_pr_reservation_check() then treat any session of the
> reservation holder's initiator as the holder:
>
> - after RESERVE(6) on one session, another session of the same
>   initiator can still write;
> - with a Write Exclusive persistent reservation, another session that
>   is not registered, or registered but not the holder, can still write.
>
> Reproduced with two open-iscsi sessions (ifaces default and if2) to a
> ramdisk LUN: on v6.12.113 every command from the second session
> completes with GOOD; with this patch TEST UNIT READY and WRITE(10)
> under RESERVE(6), and WRITE(10) under Write Exclusive, return
> RESERVATION CONFLICT, and READ(10) is still allowed.
>
> Convert all six bytes. Text that is not exactly twelve hex digits keeps
> the old conversion of its first eight characters, now copied into a
> zeroed buffer so that a shorter string, such as an initiator_sid written
> to res_aptpl_metadata, is not read past its end.
>
> An all-zero ISID now converts to 0, which
> target_scsi2_reservation_reserve() took to mean "no ISID". Set
> DRF_SPC2_RESERVATIONS_WITH_ISID when the fabric reports ISIDs instead.
> Also update the TransportID parser comment that referred to the
> get_unaligned_be64() read.
>
> Initiators that relied on the old behaviour, reserving through one
> session and writing through another without registering it, will now
> see RESERVATION CONFLICT, as SPC requires.
>
> Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v=
4.1")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ciro Iriarte <ciro.iriarte+software@gmail.com>

[Severity: Low]
e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
added drivers/target/iscsi/ and did not touch any of these files.  The
get_unaligned_be64() ISID conversion and sess_bin_isid checks in target
core were introduced in c66ac9db8d4a ("[SCSI] target: Add LIO target core
v4.0.0-rc6").

[ ... ]

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
> index ca1a2802aa228..c59032228f3ab 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -19,6 +19,7 @@
>  #include <linux/fcntl.h>
>  #include <linux/fs.h>
>  #include <linux/fs_struct.h>
> +#include <linux/hex.h>
>  #include <scsi/scsi_proto.h>
>  #include <linux/unaligned.h>
> =20
> @@ -30,6 +31,28 @@
>  #include "target_core_pr.h"
>  #include "target_core_ua.h"
> =20
> +/*
> + * lio_sess_get_initiator_sid() prints the six ISID bytes as twelve hex
> + * digits, and iSCSI TransportIDs carry the same digits.  Convert all six
> + * bytes: reading the first eight digits as a big-endian u64 keeps only =
the
> + * first four ISID bytes, so two sessions of one initiator that differ o=
nly
> + * in the qualifier, the usual case, would compare equal.  Text in any o=
ther
> + * format keeps the old conversion of its first eight characters, without
> + * reading past the end of a shorter string.
> + */
> +u64 target_isid_to_bin(const char *isid)
> +{
> +	u8 bin[6];
> +	char raw[8] =3D {};
> +
> +	if (strnlen(isid, 2 * sizeof(bin) + 1) =3D=3D 2 * sizeof(bin) &&
> +	    !hex2bin(bin, isid, sizeof(bin)))
> +		return get_unaligned_be48(bin);
> +
> +	memcpy(raw, isid, strnlen(isid, sizeof(raw)));
> +	return get_unaligned_be64(raw);
> +}

[Severity: High]
Does converting all six ISID bytes here cause
core_scsi3_pr_seq_non_holder() to treat other registered sessions of the
reservation holder's initiator as unregistered?

When an initiator opens two iSCSI sessions with different ISID qualifiers,
registers both, and acquires a persistent reservation on the first
session, a command on the second session reaches
target_scsi3_pr_reservation_check() with pr_reg_nacl =3D=3D sess->se_node_a=
cl
and pr_reg_bin_isid !=3D sess->sess_bin_isid:

drivers/target/target_core_pr.c:target_scsi3_pr_reservation_check() {
    ...
	if (dev->dev_pr_res_holder->isid_present_at_reg) {
		if (dev->dev_pr_res_holder->pr_reg_bin_isid !=3D
		    sess->sess_bin_isid) {
			isid_mismatch =3D true;
			goto check_nonholder;
		}
	}
    ...
}

drivers/target/target_core_pr.c:core_scsi3_pr_seq_non_holder() {
    ...
	if (isid_mismatch) {
		registered_nexus =3D 0;
	} else {
		struct se_dev_entry *se_deve;

		rcu_read_lock();
		se_deve =3D target_nacl_find_deve(nacl, cmd->orig_fe_lun);
		if (se_deve)
			registered_nexus =3D test_bit(DEF_PR_REG_ACTIVE,
						    &se_deve->deve_flags);
		rcu_read_unlock();
	}
    ...
}

Because DEF_PR_REG_ACTIVE is tracked per se_dev_entry (shared across all
sessions of the initiator) rather than per session, the isid_mismatch
branch unconditionally forces registered_nexus =3D 0 instead of checking
whether cmd->se_sess has its own registration in
dev->t10_pr.registration_list.  In a multipath setup where both sessions
are registered, writes on the second session under Registrants Only or All
Registrants reservations (as well as PREEMPT, CLEAR, or RELEASE from that
session) will now fail with TCM_RESERVATION_CONFLICT.

[ ... ]

> @@ -866,7 +893,7 @@ int core_scsi3_alloc_aptpl_registration(
>  	 * SCSI Initiator Port, restore it now.
>  	 */
>  	if (isid !=3D NULL) {
> -		pr_reg->pr_reg_bin_isid =3D get_unaligned_be64(isid);
> +		pr_reg->pr_reg_bin_isid =3D target_isid_to_bin(isid);
>  		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
>  		pr_reg->isid_present_at_reg =3D 1;
>  	}

[Severity: Critical]
This problem wasn't introduced by this patch, but can
core_scsi3_alloc_aptpl_registration() corrupt pr_tmpl->aptpl_reg_list
[1] by calling list_add_tail() without holding
pr_tmpl->aptpl_reg_lock?

target_pr_res_aptpl_metadata_store() calls
core_scsi3_alloc_aptpl_registration() without taking aptpl_reg_lock:

CPU0                                  CPU1
target_pr_res_aptpl_metadata_store()  __core_scsi3_check_aptpl_registration=
()
  core_scsi3_alloc_aptpl_registration() spin_lock(&pr_tmpl->aptpl_reg_lock)
    list_add_tail(...,                  list_del(&pr_reg->pr_reg_aptpl_list)
      &pr_tmpl->aptpl_reg_list)           <-- list corruption / use-after-f=
ree

Concurrent configfs writes through separate file descriptors, or a
configfs write racing with LUN export in
__core_scsi3_check_aptpl_registration() or teardown in
core_scsi3_free_all_registrations(), manipulate pr_tmpl->aptpl_reg_list at
the same time and can corrupt the list.

[1] https://sashiko.dev/#/bug/linux-620bb3ae-6c71-4e47-b64f-f502f2ef27c0

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/591ac67a-fa1e-4395-=
9573-2d9405cfe0b6@gmail.com?part=3D1
