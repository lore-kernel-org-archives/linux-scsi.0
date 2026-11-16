Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837070;
	b=jmjW6v6Ok4YoucDT660wjX015RS40ZDxjQLCk9sDH9jNYfFdmHYZdzqUQsUnz5h4QJH1
	 tbuusOpv9lu9X+d1iYF0ydqFcCYTCwNDYP6/Rhy3qpHcq+T0Zk/FmZjpxyBp9hOFTQdWK
	 CcYfXR8T7nHPJr08XiUmFKgnZW5yud8r+oJqlqABBMBHNgSrr/dvk0QJpbtL22pRicl9Z
	 tizlc49grdFYWjfFMn/rl7oT5f/rPURN6hrIfKSSN3WgG+1ELtEOaDh03mNPgBrfC7C++
	 mzGypU8upkHClKbgv7wwN8UyFdvJFQwzVeIjN+p/U18pCTNAJV5RqJZGP6OE6Tk2eCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837070;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oyQA/Z9MIvrgsYZ0eOkaCj//tUnE16fVi15SjMV2tQ4=;
	b=CAIlNkb3rfxlVrD2l9FKkObPLfFkTlZWSd1LB+dz/y8pgp/uXD6s83sD1QhIzxAmcx8h
	 TJ3/AHrQWLXP2Yqtc/MpUgrE8DcRBaZ2u8Qbm7edgFUGkbBFM41hxsPmDz2saZpaW/8iq
	 3EM7j+61/HCdURNOb6IcpGbuNPMjHZnVTQuQ+0HVyKVBxJl2Bq9ZazSl9WJfO3vUKPU3W
	 3OuVw1tLE6XIlnGjkxHE2AA6oXGRPtA5K1qXWeME+HTWPZMtzqgYn0NKpSsB2fKTCJxv2
	 Ux9nP9oq6SPfnveg4UehtCF3bYsieyVXT6hbwadWF16ch7R9Om/z+LMiRD2orup6XZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eH9hdOeL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6554A606A8BC
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eH9hdOeL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60981F000C5;
	Mon, 16 Nov 2026 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837070;
	bh=oyQA/Z9MIvrgsYZ0eOkaCj//tUnE16fVi15SjMV2tQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eH9hdOeLbStXx6szAnxTi4CjhCdxriOzyTfFa9DRqsktlUUf+3wEuafDhQ4poi22B
	 gZJRBaEsLLDWEYPb5yM52LuHc86HDginQg4u71sejFHRyZU1Xf1aam/OtKCSE5co8S
	 m691IfQabEBFRTMxsBxsORO2Z/nT5qrqT2VYsYwHM83edlMEGyW3Na5kSSk7nJtoui
	 w70CuRoR8BH4EeEkRDSFLEQuz7LNsYOCdr1DrX8Othf6feF6f8Z8IsSGmVpOgMNWcX
	 vXSjNo5+EpQZWimg7Jjdqo1QiHQQ7t4qR05kNcvttNIuaQ06quMtoxkFiOOUzQz6Zo
	 Xd/4QlBY5FE7A==
Message-ID: <sashiko-outbox-217115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Use ufshcd_query_attr_retry() for RTC
 update
Reply-To: sashiko-reviews@lists.linux.dev
To: "Enric Balletbo i Serra" <eballetb@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
References: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 13:51:09 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: ufs: core: ufshcd_query_attr_retry() still logs dev_err on
  transient error
--

commit 9b18c975bcb0273e30706599adab61914367c5c2
Author: Enric Balletbo i Serra <eballetb@redhat.com>

scsi: ufs: core: Use ufshcd_query_attr_retry() for RTC update

This commit switches ufshcd_update_rtc() from ufshcd_query_attr() to
ufshcd_query_attr_retry() when writing QUERY_ATTR_IDN_SECONDS_PASSED.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3c28bc67c65f1..1cd32b7cc9674 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8821,8 +8821,8 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
>  	if (ufshcd_rpm_get_if_active(hba) <=3D 0)
>  		return;
> =20
> -	err =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR=
_IDN_SECONDS_PASSED,
> -				0, 0, &val);
> +	err =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +				     QUERY_ATTR_IDN_SECONDS_PASSED, 0, 0, &val);

[Severity: Low]
Does ufshcd_query_attr_retry() avoid escalating to dev_err() on transient
failures as described in the commit message?

ufshcd_query_attr_retry() calls ufshcd_query_attr() on every attempt, and
ufshcd_query_attr() logs dev_err() unconditionally on any error other than
-EOPNOTSUPP:

drivers/ufs/core/ufshcd.c:ufshcd_query_attr() {
	...
	err =3D ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
	if (err =3D=3D -EOPNOTSUPP)
		goto out_unlock;
	if (err) {
		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err =3D=
 %d\n",
				__func__, opcode, idn, index, err);
		goto out_unlock;
	}
	...
}

Retrying allows a transient OCS_INVALID_COMMAND_STATUS failure to recover
and avoids the "ufshcd_update_rtc: Failed to update rtc 15" message, but
"ufshcd_query_attr: opcode 0x04 for idn 15 failed, index 0, err =3D 15" is
still logged at dev_err level on the initial failed attempt.

Also, callers in ufs-hwmon.c, ufs-sysfs.c, and ufs-txeq.c call
ufshcd_query_attr() directly, so ufshcd_update_rtc() is not the only direct
caller in drivers/ufs/core/.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-ufs-rtc-qu=
ery-retry-v1-1-4de69b175e8d@redhat.com?part=3D1
