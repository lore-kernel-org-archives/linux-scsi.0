Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006356;
	b=jwLdFD1m4MpzvW/3IST/jCkCMoDMtOuKyT6OnMj5AD3afLpHGz+lYXv1zyiSW72IzAkM
	 zOpDeIcWc/il5T0iB299LjfkzjYhsoH8ZKOYP3Am+On1a7wunzbncM62WMFgorj44CjuX
	 +5lsoPDuzmWs/4UuIB7r8fW/8NnXIsQuR5p41wt9f4A1kVjPHIgDqlwY0gr2VE18ohu81
	 emRVnUBBbGe2WmLfMhzyPuifwfLyOBbtTSkc0dNQd+tNKO3JOlqvWkGrQSYJg+V4cxfTF
	 kPiT3ZBImK8dKmMKror9RKZXqAiP2pYhdhoYplgyVucrcuLAl70MQiCN6mthEPgUPIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006356;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LuZTBKxt/fY58RQ250soO5fmfF6sn0IgZsz/Po1aw+o=;
	b=oAG3gOaf+Xqcj2U9qPkQ//UekPYYwe4JDf6TSVAnDfnvG6f7dKTSdh/vUmCvvX9HgW1E
	 HJFoKrXU0wupWGsfg2t3E6zowrKg+oz0nRHgD2NDl8rJJvNdEoYAlg7N/5mmyLb84tf1C
	 9DmsdVMydWI+gYkuswxpO/tp4Dl9nbmdg/9g5Gb0xczEnOBo2EoEnORGlZGorVTPSFCb5
	 6S03dPQRQrOmYY1mKzGK/gvafsp54482mhDM5C++loUz795HY164tJqILwFw3s/BErqfG
	 hGIC/VXiRguU+hb2KZ/BT9ULoKXsejNIdIzVAT9V11z1fowklSUYZlhtMjJDX1Tg2ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OtchnOD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E961606A31F;
	Mon, 26 Oct 2026 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OtchnOD2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923761F031E4;
	Mon, 26 Oct 2026 09:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793006355;
	bh=LuZTBKxt/fY58RQ250soO5fmfF6sn0IgZsz/Po1aw+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OtchnOD2gFsboDTrenfAF3diq7dbh/SZkK9J11xGWkYCGT+uetfGMyEk346wwNfj4
	 LBbD0D1hHVn/NvSpMVhjXBFgZvKcFFwEw8fVnGozat50jR9LnJ+mcw3/5xDrpVhjgi
	 +geazdoPkZlcm6MJu4WcU7nGSnXouwMGbelNs+ilP8L65oRKaDOgVfVM3hIew1o+nU
	 BokiOmfnF7cs/t7wD+Q+WSdVZ0mASSEa9jaRrNfyjYFJG3zcqisGQtozIjgiSSJ3Kr
	 3JzxAvfTt7H8in4iLPqwLu5q/cw+8lyVEdSWsuA3SrE3cECGbQveSfNmwIMWXBXwUV
	 nmcxAogfhfvhQ==
Message-ID: <sashiko-outbox-184760@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: Verify the iSCSI ISID is NUL-terminated
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuanhe Shu" <xiangzao@linux.alibaba.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026044632.1738901-1-xiangzao@linux.alibaba.com>
References: <20261026044632.1738901-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:19:15 +0000
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
- [High] scsi: target: 8-byte OOB read in __core_scsi3_do_alloc_registratio=
n()
--

commit 9e538bce0beb997676ced65cf68b1194c6fc594a
Author: Yuanhe Shu <xiangzao@linux.alibaba.com>

scsi: target: Verify the iSCSI ISID is NUL-terminated

This patch verifies that the iSCSI ISID in a FORMAT CODE 01b TransportID
contains a NUL terminator within the descriptor before returning a pointer
into the PERSISTENT RESERVE OUT parameter list buffer. This aims to prevent
string operations in the registration code from reading past the end of the
mapped buffer.

> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/tar=
get_core_fabric_lib.c
> index 2853b95b2c597..e15f5118b2099 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -371,6 +371,17 @@ static bool iscsi_parse_pr_out_transport_id(
>  			pr_err("Missing ISID in iSCSI Initiator port TransportID\n");
>  			return false;
>  		}
> +		/*
> +		 * The conversion loop below only scans the ISID without
> +		 * ever terminating it, but the registration code reads it
> +		 * as a C string.  With no NUL inside the TransportID,
> +		 * the reads run past the descriptor, and past the
> +		 * mapped buffer when the descriptor ends the buffer.
> +		 */
> +		if (!memchr(p, '\0', buf + tid_len - p)) {
> +			pr_err("Missing NUL terminator for ISID in iSCSI Initiator port Trans=
portID\n");
> +			return false;
> +		}
>  		*port_nexus_ptr =3D p;

[Severity: High]
Does checking only for a NUL byte within buf + tid_len - p still leave an
out-of-bounds read when the remaining length is between 1 and 7 bytes?

Both the SPEC_I_PT path and the REGISTER AND MOVE path pass *port_nexus_ptr
(as iport_ptr / isid) into __core_scsi3_do_alloc_registration():

  core_scsi3_decode_spec_i_port()
    -> __core_scsi3_alloc_registration(..., iport_ptr, ...)
      -> __core_scsi3_do_alloc_registration(..., isid, ...)

  core_scsi3_emulate_pro_register_and_move()
    -> core_scsi3_alloc_registration(..., iport_ptr, ...)
      -> __core_scsi3_alloc_registration(..., isid, ...)
        -> __core_scsi3_do_alloc_registration(..., isid, ...)

In drivers/target/target_core_pr.c:__core_scsi3_do_alloc_registration(),
before copying isid with snprintf(), the code unconditionally reads 8 bytes
from isid:

	if (isid !=3D NULL) {
		pr_reg->pr_reg_bin_isid =3D get_unaligned_be64(isid);
		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
		pr_reg->isid_present_at_reg =3D 1;
	}

If a FORMAT CODE 01b TransportID at the end of the parameter list buffer
has 1 <=3D buf + tid_len - p < 8 bytes after the ",i,0x" separator and
includes a '\0' byte, memchr(p, '\0', buf + tid_len - p) succeeds, but
get_unaligned_be64(isid) still reads up to 7 bytes past buf + tid_len (and
into the trailing vmalloc guard page on multi-page mappings).

Should get_unaligned_be64() read from the zero-initialized
pr_reg->pr_reg_isid buffer after snprintf(), or should
iscsi_parse_pr_out_transport_id() require the full ISID length?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026044632.1738=
901-1-xiangzao@linux.alibaba.com?part=3D1
