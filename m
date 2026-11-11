Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794405536;
	b=2jtYC5KI3j24uRViXKVTXCbeZiUTnTOMvizwxLW6HwMdq81ZIA9VcQN+qZTtRzMT7MrJ
	 x4ZTAPZNhOHG0x91/AGo+50VCqgsmfTQhQY91ZZGgun/CIhwhhEUOah7OR0OTb63oItbg
	 U3oy9amRHiCIwYbPdk9eFDrLtr+ycxDBRAdhuzEsA7YIwfBqb0WyyQnhcIXws/pxrrZMK
	 9u0m37ExqfxWj1njKoTRQPkB56aG9rok8NeKWkWRs1VZ290nJLUM+3J/heZmHo5eEu6O1
	 nvWsGETl2A8D+gN5N7cNjR7nCdcYmq2OD36/TFLX+YrBX0nPiM5PjbHfoWsqoNgiGNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405536;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d/urBojdAE08TyPMaN1zJQuxspH3TfMcrsmwhPXJVDo=;
	b=BeiLyN7kazzu09aDdUQfHcylJzacBta5E4zH1MIwTcJwX2L/pGaJ4dIQ9dba9ZNcW6o/
	 kmyku4l66xMGKRQl3/RCmLEjQP9A9R19NbmvMwvxBjAqVxcJXAJZVROqJvrA+NF72vqgE
	 LZQF0quuGJIgQMNDp7OnnVJ/64OZrbrDDHa3ghvfa6qOHXmmEHqgtLk0cyLAviPZCxOgG
	 UMd9wp0U5UtRBGdtIjYxcEJbFVKgFExntCUqAk63bxHZSarCwR6tyFW11dSnElUZKFcR7
	 jzJ9CsIvJqTm8eXObRKzJHpN8tniV+KAjDTahqi+8o0YwYms4tWScAH4s1pJFL69dxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2FCjkNK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C6606A326;
	Wed, 11 Nov 2026 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2FCjkNK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615EA1F00A05;
	Wed, 11 Nov 2026 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794405535;
	bh=d/urBojdAE08TyPMaN1zJQuxspH3TfMcrsmwhPXJVDo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T2FCjkNKyly5M8d82B9NPwdzgg1/NuP5I5juqn2hqIGRbSJCYar8dWVhTFZ4beN+N
	 toMj47rp4YaxZtEGhsepkJArrKKPLfphM4P5Adk6jtFM14+smdq7H6ax5R4asgCcvB
	 hcfAnqfnzKgaAwrGFfoIXhWuv3tieo/jRlyx4jQYhJVwP7wOOGkbmaN7UuEtIWAGZ6
	 BxrYvj7GicDyTOOC0aaQhkOk0GCnt3qWAHCv5cwtKdCdyDNizPTJvqakA2pB3LifYO
	 e6FRiUnCWTsiS8tGeN6tWr2feJs/7kdKTUYsf3Hrs/WiskVRmkN1Lo6Lq3V9wWUxsT
	 mdCZbTnsl+oRw==
Message-ID: <sashiko-outbox-209114@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: alua: Free target port groups with
 kfree_rcu()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261111-bug-target-alua-free-gp-v1-1-d1e692ae8694@linux.dev>
References: <20261111-bug-target-alua-free-gp-v1-1-d1e692ae8694@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:58:54 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] scsi: target: race condition in core_alua_free_tg_pt_gp() [1]
--

commit cbab3de9aa10ecf910c633ef186a6a1775418e09
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: alua: Free target port groups with kfree_rcu()

This commit replaces synchronize_rcu() and kmem_cache_free() in
core_alua_free_tg_pt_gp() with kfree_rcu() to avoid synchronous RCU waits
when deleting target port groups and backstores.

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_co=
re_alua.c
> index 140154d93c430..4ef243ae843bb 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -1771,8 +1771,7 @@ void core_alua_free_tg_pt_gp(
>  	}
>  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
> =20
> -	synchronize_rcu();
> -	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
> +	kfree_rcu(tg_pt_gp, rcu_head);
>  }

[Severity: Medium]
This problem wasn't introduced by this patch, but can the LUN detachment
loop right above this race with target_detach_tg_pt_gp() [1] and
leave a freed struct se_lun on default_tg_pt_gp->tg_pt_gp_lun_list?

drivers/target/target_core_alua.c:core_alua_free_tg_pt_gp() {
    ...
	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
	list_for_each_entry_safe(lun, next,
			&tg_pt_gp->tg_pt_gp_lun_list, lun_tg_pt_gp_link) {
		list_del_init(&lun->lun_tg_pt_gp_link);
		tg_pt_gp->tg_pt_gp_members--;

		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
		...
		spin_lock(&lun->lun_tg_pt_gp_lock);
		if (tg_pt_gp !=3D dev->t10_alua.default_tg_pt_gp) {
			__target_attach_tg_pt_gp(lun,
					dev->t10_alua.default_tg_pt_gp);
		} else
			rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
		spin_unlock(&lun->lun_tg_pt_gp_lock);

		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
	}
	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
}

When a non-default target port group is removed through configfs while a
fabric LUN in that group is being unlinked, core_alua_free_tg_pt_gp()
drops tg_pt_gp->tg_pt_gp_lock before taking lun->lun_tg_pt_gp_lock while
lun->lun_tg_pt_gp still points to tg_pt_gp:

CPU0                                   CPU1
core_alua_free_tg_pt_gp(tg_pt_gp)      target_fabric_port_unlink()
  spin_lock(&tg_pt_gp->tg_pt_gp_lock)    core_tpg_remove_lun(lun)
  list_del_init(&lun->lun_tg_pt_gp_link)   target_detach_tg_pt_gp(lun)
  tg_pt_gp->tg_pt_gp_members--
  spin_unlock(&tg_pt_gp->tg_pt_gp_lock)
                                             spin_lock(&lun->lun_tg_pt_gp_l=
ock)
                                             __target_detach_tg_pt_gp(...)
                                             rcu_assign_pointer(
                                               lun->lun_tg_pt_gp, NULL)
                                             spin_unlock(&lun->lun_tg_pt_gp=
_lock)
  spin_lock(&lun->lun_tg_pt_gp_lock)
  __target_attach_tg_pt_gp(lun,
    default_tg_pt_gp)
  spin_unlock(&lun->lun_tg_pt_gp_lock)
                                       target_fabric_port_release()
                                         ...
                                           kfree(lun)
                                       target_emulate_report_target_port_gr=
oups()
                                         /* walks default_tg_pt_gp list */
                                         lun->...  <-- use-after-free

Because core_alua_free_tg_pt_gp() does not recheck lun->lun_tg_pt_gp after
acquiring lun->lun_tg_pt_gp_lock, it re-attaches the detaching LUN to
default_tg_pt_gp after target_detach_tg_pt_gp() has already cleared it
(and decremented tg_pt_gp->tg_pt_gp_members a second time).  When port
teardown subsequently frees the LUN, a dangling entry remains on
default_tg_pt_gp->tg_pt_gp_lun_list.

[1] https://sashiko.dev/#/bug/linux-8e4ef2cb-206e-4a76-8c9e-458e67913f8b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-bug-target=
-alua-free-gp-v1-1-d1e692ae8694@linux.dev?part=3D1
