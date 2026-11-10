Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317894;
	b=bem2JLVgAhcCLtqaW5GiBzin8OBh0qjiL5j9gqX5bhnvTe0R1jI8dRlxSClOxHBWRyvz
	 YQX9BOp8G4a76MSlO/N/Y6kptj0VrYM9YBsCl+IOc8ELP4eeV7NkHm5Nh0vfzWCRGZD9F
	 iuvE2aUWZj0EV/kWIUNkzfB5XmUQx9xTFuxOmENT3fU3FFzzawLIKsN0xwGkMyma/6UhS
	 lMXD8dl9b8Q8BFe5w7AKbHJGoYFvuNg6hbToR/RJmZAU6svppFipsnFbDSY1uiZaN5oYq
	 +p5RHee+hzAbAAGUwwJmFPsx4AmNTVzpzfcYnfrp3TUV9M+N+2FiblVXen8DGg/+zJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317894;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Cn7rda/fsN+gsxd4ZiE/OhKc1bG+wmGdaNrMQHresz8=;
	b=ZWZgf/cYr2fCAgC2yasyMYQGNJjoxqLxl3YkPO3UX2cD8MJY5thCyuA9o30tj7CQzAqP
	 I4GWNOEsMqbDw+3onzV0utBC1kutN4XU8XNiCaEOQI0nIy8+QOJ0qG+SBmEH0DmK0cPGz
	 4turrLWcxRygmBBb5ZUNm2QwBZ2IFZkOdIl3MPoJe0sLg5Eu0B7ws1O8Z2OX18UHIrHbb
	 voZp7ETWthG4CHDnyRa6ituHm7kGhs+Td/WgmQQFDhBWZh0dPSap0rtD7/y1LO/WSsbkQ
	 DvuswW7nkpJtpHMAMkYJNiwr2IvX91feelChK9c4pIypvt3SZk1cSTsTm9yXOHFvurg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mQpBzkYu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92A4606A326;
	Tue, 10 Nov 2026 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mQpBzkYu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156051F0089F;
	Tue, 10 Nov 2026 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317893;
	bh=Cn7rda/fsN+gsxd4ZiE/OhKc1bG+wmGdaNrMQHresz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mQpBzkYumykchN03D31lRIN+Dr0GCc2y73yqPW68adnSWOdvXUyj1JFofKGwJFMN7
	 nTW5MD3SRKoO/0U/flHU/XrwWhFhru4G8zBag0BKnx/qizjLIjFBRnIgyWrHVzomh6
	 6uNP6r2sSGOE/aGW79caIT4Be29levtGuUcetbeHftpqootrfLZYamu+MUypFGuJ5t
	 OEMuYtcKQnZ1cP1rlFlCJp0ZDx+RYz1Q76nU9BFYkyPqyNsYfBeBjDLTaaWC6f/9XR
	 WfYmonGYbE0Dk+mFRc+4ij2hWm3MIVGfmbGcs//y5hUQ73nNgKupPutE9OuZMGPjDg
	 A+umPGH/DNUjQ==
Message-ID: <sashiko-outbox-207137@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: target: alua: Don't wait for a grace period
 when attaching a LUN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261110-bug-target-alua-lun-gp-v1-1-127a46efdae9@linux.dev>
References: <20261110-bug-target-alua-lun-gp-v1-0-127a46efdae9@linux.dev>
 <20261110-bug-target-alua-lun-gp-v1-1-127a46efdae9@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:38:12 +0000
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
- [Critical] target: out-of-bounds write in
  target_emulate_report_target_port_groups() [1]
--

commit 2f412f4b4c4324ed81aac0037066698113367ec3
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: alua: Don't wait for a grace period when attaching a LUN

This commit removes the synchronize_rcu() call from target_attach_tg_pt_gp()
when attaching a newly created LUN to the default ALUA target port group.

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_co=
re_alua.c
> index 140154d93c430..35d36cd36db6c 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -1833,7 +1833,6 @@ void target_attach_tg_pt_gp(struct se_lun *lun,
>  	spin_lock(&lun->lun_tg_pt_gp_lock);
>  	__target_attach_tg_pt_gp(lun, tg_pt_gp);
>  	spin_unlock(&lun->lun_tg_pt_gp_lock);
> -	synchronize_rcu();
>  }
> =20
>  static void __target_detach_tg_pt_gp(struct se_lun *lun,

[Severity: Critical]
This problem wasn't introduced by this patch, but can concurrent calls to
target_attach_tg_pt_gp() and target_emulate_report_target_port_groups() cau=
se
an out-of-bounds write to buf[] [1]?

drivers/target/target_core_alua.c:target_emulate_report_target_port_groups(=
) {
    ...
		if ((off + 8 + (tg_pt_gp->tg_pt_gp_members * 4)) >
		     cmd->data_length) {
			rd_len +=3D 8 + (tg_pt_gp->tg_pt_gp_members * 4);
			continue;
		}
    ...
		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
		list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
				lun_tg_pt_gp_link) {
			off +=3D 2; /* Skip over Obsolete */
			put_unaligned_be16(lun->lun_tpg->tpg_rtpi, &buf[off]);
			off +=3D 2;
			rd_len +=3D 4;
		}
		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
    ...
}

target_emulate_report_target_port_groups() checks whether the descriptors f=
or
a port group fit within cmd->data_length using tg_pt_gp->tg_pt_gp_members
without holding tg_pt_gp->tg_pt_gp_lock:

CPU0                                  CPU1
target_emulate_report_target_port_groups()
  if ((off + 8 +
       (tg_pt_gp->tg_pt_gp_members * 4)) >
      cmd->data_length)
                                      target_attach_tg_pt_gp()
                                        __target_attach_tg_pt_gp()
                                          spin_lock(&tg_pt_gp->tg_pt_gp_loc=
k)
                                          list_add_tail(...,
                                            &tg_pt_gp->tg_pt_gp_lun_list)
                                          tg_pt_gp->tg_pt_gp_members++
                                          spin_unlock(&tg_pt_gp->tg_pt_gp_l=
ock)
  spin_lock(&tg_pt_gp->tg_pt_gp_lock)
  list_for_each_entry(lun, ...)
    put_unaligned_be16(..., &buf[off])  <-- out-of-bounds write

When a concurrent configfs operation attaches a LUN to the same port group
between the size check and acquiring tg_pt_gp->tg_pt_gp_lock,
tg_pt_gp_lun_list grows past the validated count and the loop writes past t=
he
end of the mapped command buffer.

[1] https://sashiko.dev/#/bug/linux-9cff51b1-852e-4bef-94e2-6d7c000ddc21

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-bug-target=
-alua-lun-gp-v1-0-127a46efdae9@linux.dev?part=3D1
