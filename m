Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794654697;
	b=kanfRNN4xTZcVbuPzBU/87bW/5nfXM1oEeZRwRjt2v/Fyg61E8BGQPJfEUNa+inrtOow
	 6J3NdCGcFmgMcwS/dkiAmD+joAhfUW6TicGAGwa4A6GcJrQiyTVlaljlzCJohZXsRw2Bt
	 13iQ7/0MSpSejXw7UQoZu/e9nTRdMTgx++vMKE5zuq9fhSiG+Os+sEJRzF543FYphT/wM
	 6Z6uvgTPGh9qEFfoYNZIZFcFeR2STQnxQEAogislW2C7+g3Ta55l4ds3jKfJUFRX+r+rR
	 BxG9LjwM21eKlNTnMw4Rxnzp1s3doNmDCBfDMZe6JbWQ5HJ0F4MRBfmXzq9r793KbvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794654697;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cbYuMu4WUsUGCQIH0/sc2YzB04reRDp9xUgMuHbaCn4=;
	b=MPnoqfLErKw5vG8irIoWuupEFBSoUVRtVyKHAUJsL3CSf+OWpSsCfoHMDw3B6t/tmDw7
	 afwLV9XuJ2B24CkGBHW2O80G8YofM/SB6B+fLmGujuFSvTX9Dkjzi1i70cCv/5616tUoW
	 7610pYscLO5y4f3nCY/MZ7jctXZVvZ1LTymWfthp8qJjTcOrAZIvmBDVETlbPefYmjt6J
	 JTbuCpZiVOqKDHB4XmUiKMnSWxT4sus4A7HunbdvQ3iu3Ba6RSbxXxprYQYzQVt5Qyak6
	 tcSYPiXBLu1zWtjqJdiEMbxPAGCezfHsTfSyiQO2ul5AFmN/0RuITKr8IKdspggFvJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwtfAMpN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F236606A887;
	Sat, 14 Nov 2026 11:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwtfAMpN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9140B1F000C4;
	Sat, 14 Nov 2026 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794654697;
	bh=cbYuMu4WUsUGCQIH0/sc2YzB04reRDp9xUgMuHbaCn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UwtfAMpNar/KTN/dBePsvZFv6Goco8vT84PD0R/pMySX0mLppPWXfXODhwxF4L/An
	 M4unY+1vSs6uWiWq7701SFv+PcIH3RxEI5xYlORneMEdkh2/s8gaLIAqqej+PN431x
	 CyoDIRM8scltxaItI4WpC1+D4ms5FM80ne8ff/GdVaB+qvenDZaCF+ggofzW901Rqv
	 +dNsGwox2idCyxE7GBqvwM1Zq+dzVdLpITUx14SOj2GX8C7aRzpWxfWuyusLoCqyIH
	 hO0UNwzpMGfZlk7d2wrzvN5byLxISdn06W/3pBh+yKRFsmf/1icXCyNkEkBvBHAXRE
	 k4+BEspOnWkaA==
Message-ID: <sashiko-outbox-214394@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/12] bpf: fs/xattr: take freeze protection in the
 xattr kfuncs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bpf@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261114-work-fs-frozen_writes-v1-11-f5ae61c898b1@kernel.org>
References: <20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org>
 <20261114-work-fs-frozen_writes-v1-11-f5ae61c898b1@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:11:36 +0000
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
- [High] bpf: deadlock in bpf_set_dentry_xattr() via
  bpf_lsm_inode_need_killpriv() [1]
--

commit 486e046b7935f74b8ef238345d31e9322cf39132
Author: Christian Brauner <brauner@kernel.org>

bpf: fs/xattr: take freeze protection in the xattr kfuncs

This commit takes superblock freeze protection via
sb_start_write_trylock() in bpf_set_dentry_xattr() and
bpf_remove_dentry_xattr() so that BPF LSM programs cannot modify a frozen
filesystem.

> diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> index 35ccd98a4de64..7f61e2efa08ba 100644
> --- a/fs/bpf_fs_kfuncs.c
> +++ b/fs/bpf_fs_kfuncs.c
> @@ -295,9 +295,13 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *=
dentry, const char *name__st
>  	if (!inode)
>  		return -EINVAL;
> =20
> +	/* The hook may hold locks or freeze protection already. */
> +	if (!sb_start_write_trylock(inode->i_sb))
> +		return -EBUSY;
>  	inode_lock(inode);
>  	ret =3D bpf_set_dentry_xattr_locked(dentry, name__str, value_p, flags);
>  	inode_unlock(inode);
> +	sb_end_write(inode->i_sb);
>  	return ret;
>  }

[Severity: High]
This problem wasn't introduced by this patch, but can calling
bpf_set_dentry_xattr() or bpf_remove_dentry_xattr() from
bpf_lsm_inode_need_killpriv() deadlock on inode_lock(inode) [1]?

During file writes, callers of file_remove_privs_flags() ->
dentry_needs_remove_privs() -> security_inode_need_killpriv() already hold
inode_lock(inode).  Because bpf_lsm_inode_need_killpriv is missing from
d_inode_locked_hooks, the verifier routes xattr kfunc calls from that hook
to the unlocked variants instead of the _locked ones, causing the thread
to self-deadlock on inode->i_rwsem.

[1] https://sashiko.dev/#/bug/linux-8b38dfb7-78dd-457e-8674-7955f142df39

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-work-fs-fr=
ozen_writes-v1-0-f5ae61c898b1@kernel.org?part=3D11
