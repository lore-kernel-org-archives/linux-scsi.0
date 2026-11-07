Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071527;
	b=C+b269reTvu4wFLJMRISiFXMiO3N+FIyDjXdC1H+Y46YlsDnwROMOYvObe9fnotOa/Ph
	 tW7iH7jC4hrWdEWtPk5t5ImxkEBa+3Uvbs6FoPl8hIPP2jcJcG7djPstO1EGfbx+LSuDc
	 rgvyExY5wsD1b7sT4x0Ws0SAjJKOFCgrWXnkoIfkkrjSWUgEKIYOt/pG0t6Ry+q70t6gK
	 5ekU0ww/HAOXUqblProBR9oajgd4/Dm3ta9Mm7LyfeN7TujhlI6vCCZ5UyBCzyOSJFnjb
	 LuK7XSlI6In8B/MskSni8VDJsrV7m5bdx2hfLIBl0UiuwAHbNjGUVHL+8UsnrsiXPxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071527;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zs7GW3xIkb258b7bH0cCAJ+k9M0mldsHnPCRsrSeXjM=;
	b=vmu+aWx3ISo80OgISlX1CTjUEF5ohbnqj/zSHLu8/qAL58spp6fIzAa8XYsTv7SC/GNq
	 rpWMuzeJpwRcTKugfdik4A/AmZj38EAMxDveKfEj97qYn6zk7gcNMCPdeheVEkJqOtgoR
	 5+Ws/3FjcoFwS/C3A1MzYAJ3cMX6owRg46OLVIzr04lElaqWAB4G1AnYcj5e+D4iPpRN9
	 xqbBRHn4u390dI0N9xp/P4GL6b9Frtk5JEwsXRxKZOYNDV+hWC/CCb2DSI3TdZdsDzt/7
	 EqC6ieHZFet33AaL5fpt2q0zyUqI0JANJ0UFDsDN33WsWfqEYkSKixeOCEiIxYbxFKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVZeCVmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69680606A326
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BVZeCVmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267FD1F0089F;
	Sat,  7 Nov 2026 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794071527;
	bh=Zs7GW3xIkb258b7bH0cCAJ+k9M0mldsHnPCRsrSeXjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BVZeCVmQkQQGBpuRFv5NtIdnVuZgtoR79hZUKOKRuN//AWXspuK3lVo2rHaPQBHq+
	 IOsPsPAZGNxXdaO0NzQteaECoMGRO6LZT7BJLVztrClk7+Q4ipJlXSxg/lNw4uResg
	 IYKNw4N2RNDNbYJt1E+OJIbabJy37pZ5urh2m/QbbEwBaycz0aY7vQJIDyUAKf0Uwk
	 mZryf4K2RmOJyUtqm1FVSBFpRIO+SYvvuK7PB7jHimBueJ5KKzz5HH6VXe2YdeULV2
	 SldsykbcEyXprP5W9DW2B7hKNElvBGNur/0njPoqbQYd115SiUtaYF5BJCvlhxd2M3
	 4WSf9YCMk8tsg==
Message-ID: <sashiko-outbox-203096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [GIT PULL] SCSI fixes for 7.4-rc1+
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <49923933505639f8c35894464a0a8c57773d4877.camel@HansenPartnership.com>
References: <49923933505639f8c35894464a0a8c57773d4877.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 17:12:06 +0000
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
- [High] scsi: target: premature ACL publication in
  core_tpg_check_initiator_node_acl()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] scsi: target: tcmu: TOCTOU race on max_blocks in configfs param
  setters [1]
--

commit f9d11da432d3548975ae975a55e7c7c925a3b8f1
Author: James Bottomley <James.Bottomley@HansenPartnership.com>

SCSI fixes for 7.4-rc1+

This merge commit collects scsi driver, core, bsg, ufs, and target fixes,
including target acl and tcmu parameter handling updates.

[ ... ]

> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_cor=
e_tpg.c
> index ccff9f6e48266..e615e5e304273 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -266,6 +266,15 @@ struct se_node_acl *core_tpg_check_initiator_node_ac=
l(
>  	kref_get(&acl->acl_kref);
>  	acl->dynamic_node_acl =3D 1;
> =20
> +	/*
> +	 * Publish the dynamic NodeACL on tpg->acl_node_list before creating
> +	 * its demo-mode MappedLUN dev entries below, so that a concurrent LUN
> +	 * teardown sweep (core_clear_lun_from_tpg(), which walks acl_node_list)
> +	 * can observe and disable those dev entries.  Otherwise a dev entry can
> +	 * be left on an se_lun->lun_deve_list that is about to be freed.
> +	 */
> +	target_add_node_acl(acl);
> +
>  	/*
>  	 * Here we only create demo-mode MappedLUNs from the active
>  	 * TPG LUNs if the fabric is not explicitly asking for
> @@ -275,7 +284,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
>  	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) !=3D 1))
>  		core_tpg_add_node_to_devs(acl, tpg, NULL);
> =20
> -	target_add_node_acl(acl);
>  	return acl;
>  }
>  EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);

[Severity: High]
Does moving target_add_node_acl() before core_tpg_add_node_to_devs()
publish acl on tpg->acl_node_list before its demo-mode lun entries and
session are attached?

target_add_node_acl() links acl onto tpg->acl_node_list and drops
tpg->acl_node_mutex while acl->lun_entry_hlist and acl->acl_sess_list are
still empty.  A concurrent login from the same initiator can then look up
acl via core_tpg_get_initiator_node_acl(), see an unpopulated lun map, and
if that second session tears down before the first session registers on
acl->acl_sess_list (when tpg_check_demo_mode_cache() is false),
transport_free_session() sees an empty acl_sess_list and unlinks and drops
acl:

CPU0                                  CPU1
core_tpg_check_initiator_node_acl()
  target_add_node_acl(acl)
                                      core_tpg_check_initiator_node_acl()
                                        core_tpg_get_initiator_node_acl()
                                          -> returns acl
                                      ...
                                      transport_free_session()
                                        list_empty(&acl->acl_sess_list)
                                        acl->dynamic_stop =3D true
                                        list_del_init(&acl->acl_list)
                                        target_put_nacl(acl) (x2)
  core_tpg_add_node_to_devs(acl, ...)
  ...
  transport_free_session()
    target_put_nacl(acl)              <-- refcount underflow / use-after-fr=
ee

Because CPU0's core_tpg_add_node_to_devs() runs after acl has been
unlinked from tpg->acl_node_list, its new se_dev_entry objects are also
missed by core_clear_lun_from_tpg() on lun removal, leaving dangling
entries on se_lun->lun_deve_list.

In addition, a concurrent core_dev_add_lun() walking tpg->acl_node_list
under tpg->acl_node_mutex can call core_tpg_add_node_to_devs(acl, tpg,
lun) before CPU0 calls core_tpg_add_node_to_devs(acl, tpg, NULL),
replacing the first demo-mode se_dev_entry in
core_enable_device_list_for_node() and leaking its per-cpu new->stats when
orig is freed via kfree_rcu().  Likewise, core_tpg_add_initiator_node_acl()
can find acl and clear acl->dynamic_node_acl =3D 0 before
core_tpg_add_node_to_devs() runs, attaching demo-mode lun entries to an
explicit acl.

> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_co=
re_user.c
> index 425ad1246a759..07b5146781767 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2524,6 +2524,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu=
_dev *udev, substring_t *arg)
>  		return ret;
>  	}
> =20
> +	if (val <=3D 0) {
> +		pr_err("Invalid data_pages_per_blk %d.\n", val);
> +		return -EINVAL;
> +	}
> +
>  	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
>  		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %=
d -> %zd pages).\n",
>  		       val, udev->data_area_mb,

[Severity: High]
This problem wasn't introduced by this patch, but can concurrent configfs
writes to tcmu_set_data_pages_per_blk() and tcmu_set_max_blocks_param()
race [1] to set udev->max_blocks to 0?

Both helpers validate udev->data_area_mb and udev->data_pages_per_blk
before acquiring udev->cmdr_lock:

CPU0                                  CPU1
tcmu_set_data_pages_per_blk()         tcmu_set_max_blocks_param()
  val <=3D TCMU_MBS_TO_PAGES(
           udev->data_area_mb)
                                        TCMU_MBS_TO_PAGES(val) >=3D
                                          pages_per_blk
                                        mutex_lock(&udev->cmdr_lock)
                                        udev->data_area_mb =3D val
                                        udev->max_blocks =3D ...
                                        mutex_unlock(&udev->cmdr_lock)
  mutex_lock(&udev->cmdr_lock)
  udev->data_pages_per_blk =3D val
  udev->max_blocks =3D
    TCMU_MBS_TO_PAGES(
      udev->data_area_mb) / val       <-- evaluates to 0
  mutex_unlock(&udev->cmdr_lock)

When tcmu_configure_device() later allocates udev->data_bitmap with
bitmap_zalloc(), udev->max_blocks =3D=3D 0 returns a zero-size pointer that
faults on subsequent bitmap operations.  In the reverse interleaving,
tcmu_set_max_blocks_param() computes udev->max_blocks from a stale
pages_per_blk snapshot before udev->data_pages_per_blk is increased,
leaving udev->max_blocks * udev->data_blk_size larger than
udev->data_area_mb.

Checking and updating both parameters under udev->cmdr_lock would avoid
the race.

[1] https://sashiko.dev/#/bug/linux-873290f2-6e60-4ebc-a4fd-858ba6bf6b4b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/49923933505639f8c35=
894464a0a8c57773d4877.camel@HansenPartnership.com?part=3D1
