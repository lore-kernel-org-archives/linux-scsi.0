Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927398;
	b=DK70Lxzo0h9HosK39xKj3zXq+bpyZ7BiY1Qz50mZUPTaI5MjvbZgXPiCFkLiwwH2+MGC
	 /tqXT6uaIvynG/vfeOSgqxiZtJsuRAiVF4BN6UUHnI9Xx1UZBC09MhjTM2w7ikYtvgUDm
	 F6ieywLl0fIYKM+7hKvZ/609uMKvaymqjJvMsQsVhq/WgzHFxGC7DIrkJ52j2QVomJUS7
	 8cN/N5ffy/lWU5lqIfS6RQXxpNkV7HI1cMMhFNA1CDma8mZH5VFOJz80oseK8jc9CVK2p
	 /iiaoz7/0Q+1IF76Mv4fKrdJhm0Qowgy/RLHXqGoQPL1ntrPWcp0jPJPgLmePdpsrNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927398;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d6Po/4S41WwS28gBYvglr8QXYVbUgRIen02+PqloiBw=;
	b=5bnDQmRxKOkeEZi2wXfkKnZlZ95NxX6Htxwf46slhO7APISK96xPtLqWjO+b6SRxUY2C
	 3Yk0ZKaAWpANd8nDsAfmh/944z9agDWfYUFGZCf4XE/aoWmaN5RWh6FiGuK2n5wDa7Ily
	 fo0fbLMXVdy9jT3JQHQka6voUBzlHXgvJC/xBWBSKVMKlSBwGku8EjuctTEtOJMFb32TH
	 WFQRQ98c0FIXH+Wbw9opa39BDTR9LFx3J3ypYtZB2kxw9DQ5QKsO4j3Gy3Sb5PBl9dfSn
	 K7lzS5IpShaB+QX5PqjD4LQWTU8B9RIE2P4PGfcGMcWWcWtsl17SIy/HGN2mKhjLgvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlyuAKW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B1606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlyuAKW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5F81F0089F;
	Fri,  6 Nov 2026 01:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927397;
	bh=d6Po/4S41WwS28gBYvglr8QXYVbUgRIen02+PqloiBw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=LlyuAKW7gLul33N/H6EVQiIR9nMHvKc+zS6Ahz5lPKvQTyz51wQeAotaym1VCS8c0
	 k6653jG3rHX1TNVDmS66QTcirDN99CW1uetagmZaPNIqd9uuNDXx6tvSgyEhPj/rf0
	 ytkI6doykyCrl2Qb2FocD+1zEdn+pyjc1C9xIrPyHMARhtDVFJ0TMYcyExFq28CzUT
	 n4OGZu093cev5xTLQpAVjz79Ow8RD7jMWlXI6RtX4+U6lspqP7DdAQBRnguvHFSzqd
	 2W0hyCGJGFuwjMehfQNqO6gzR7XBb9+ywRuSSSU+DbXRINCu3hjcMzSU0rTQlQlgEh
	 nAhLBx3fmzQ+w==
Message-ID: <sashiko-outbox-200482@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/37] scsi: mpt3sas: Clamp ValidEntries in driver
 trigger page update helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:09:56 +0000
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
- [Medium] scsi: mpt3sas: signed count bypasses clamp in trigger update hel=
pers
--

commit ae22d6dc5a3a1081272d193a5d2d62df9244f533
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Clamp ValidEntries in driver trigger page update helpers

This commit clamps ValidEntries to NUM_VALID_ENTRIES in the pg2, pg3, and
pg4 driver trigger update helpers before using it as a loop bound and trigg=
er
count.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas=
/mpt3sas_config.c
> index 75312d43e3862..ddbccbac69b34 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -2278,6 +2278,8 @@ mpt3sas_config_update_driver_trigger_pg2(struct MPT=
3SAS_ADAPTER *ioc,
> =20
>  	if (set) {
>  		count =3D event_tg->ValidEntries;
> +		if (count > NUM_VALID_ENTRIES)
> +			count =3D NUM_VALID_ENTRIES;
>  		tg_pg2.NumMPIEventTrigger =3D cpu_to_le16(count);
>  		for (i =3D 0; i < count; i++) {
>  			tg_pg2.MPIEventTriggers[i].MPIEventCode =3D
> @@ -2437,6 +2439,8 @@ mpt3sas_config_update_driver_trigger_pg3(struct MPT=
3SAS_ADAPTER *ioc,
> =20
>  	if (set) {
>  		count =3D scsi_tg->ValidEntries;
> +		if (count > NUM_VALID_ENTRIES)
> +			count =3D NUM_VALID_ENTRIES;
>  		tg_pg3.NumSCSISenseTrigger =3D cpu_to_le16(count);
>  		for (i =3D 0; i < count; i++) {
>  			tg_pg3.SCSISenseTriggers[i].ASCQ =3D
> @@ -2595,6 +2599,8 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT=
3SAS_ADAPTER *ioc,
> =20
>  	if (set) {
>  		count =3D mpi_tg->ValidEntries;
> +		if (count > NUM_VALID_ENTRIES)
> +			count =3D NUM_VALID_ENTRIES;
>  		tg_pg4.NumIOCStatusLogInfoTrigger =3D cpu_to_le16(count);

[Severity: Medium]
Can a ValidEntries value with bit 31 set (>=3D 0x80000000) bypass this clam=
p in
mpt3sas_config_update_driver_trigger_pg2(),
mpt3sas_config_update_driver_trigger_pg3(), and
mpt3sas_config_update_driver_trigger_pg4()?

In drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h, ValidEntries is declared as
uint32_t in struct SL_WH_EVENT_TRIGGERS_T, struct SL_WH_SCSI_TRIGGERS_T, and
struct SL_WH_MPI_TRIGGERS_T, whereas count in these three helpers in
drivers/scsi/mpt3sas/mpt3sas_config.c is a signed int:

	int rc, i, count;

The sysfs store handlers diag_trigger_event_store(),
diag_trigger_scsi_store(), and diag_trigger_mpi_store() in
drivers/scsi/mpt3sas/mpt3sas_ctl.c copy user data into event_tg, scsi_tg, or
mpi_tg and call these update helpers before clamping ValidEntries:

	memcpy(event_tg, buf, sz);
	if (!event_tg->ValidEntries)
		set =3D 0;
	if (mpt3sas_config_update_driver_trigger_pg2(ioc, event_tg,
	    set)) {

When a user passes ValidEntries >=3D 0x80000000, assigning it to the signed=
 int
count makes count negative. The signed comparison count > NUM_VALID_ENTRIES
then evaluates to false, the for (i =3D 0; i < count; i++) loop copies zero
entries, and cpu_to_le16(count) writes the truncated unclamped u16 value in=
to
tg_pg2.NumMPIEventTrigger, tg_pg3.NumSCSISenseTrigger, or
tg_pg4.NumIOCStatusLogInfoTrigger before committing the page to the
controller.

Should count (and i) be unsigned, or should event_tg->ValidEntries,
scsi_tg->ValidEntries, and mpi_tg->ValidEntries be clamped using min_t(u32,
..., NUM_VALID_ENTRIES) before assigning to count?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D17
