Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A16221FD4;
	Mon,  5 Oct 2026 11:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201323; cv=pass; b=n5lhiRPr2iin1YsuDrcp4pe/bWdSA66uL9nSBHE374niE4P8+gp62YYjn4/gRc4f8RFNnQL/Y0QNrJo6Z6xbJZyGsUEMGqm4wofxjm0yy8Hz6sYDfOpzNWy43+xi8BvqfmY1H5fLCdR8YuBznWHbwZTzLvTWkt7Oy9agum6Xir8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201323; c=relaxed/simple;
	bh=ck8/UTx5CCxvmelK4jSyBm8N+nwsqu5R9ItOFQBEQH8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UYjhxmKe7nh5Qyywe3sWLLrh4Y/213XxBywNulMMvdjiQDISfrxCEdwLLs7LCh/VI7w8mKE2ViWZR585b7jpL+a6H7zO0Xw6qGS6SRrBOlDIcebgkCdaB7POH1KCqwkLI8vkm2HOFN7FapcAgotNDsH28BJLM2Xb9yMA6gbogNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=GQJ/rxyY; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=BjTpxYHY; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="GQJ/rxyY";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="BjTpxYHY"
ARC-Seal: i=1; a=rsa-sha256; t=1791201271; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=GZjD9ZxuN4+NRA9jvrOsL27KMR/E04LwmXRwbn3flrtQXOCS5tCwajYixVuLsyns9h
    OerJLKd5xnDtpHTXjkT9IZG4EBR1jBNIzcQ88ZlbV2UH0I9d63iSPkG/PZlKCkCqQNAk
    rHrxOFxJ4aNg56i+Lw3Msd7GoDwxwSpvF9kfViYweYn8O7XBjPW93daBRuMksB3op+jG
    HqEL/QFfPClPV9Qc3kkRfLWz0BymR4S2rNVy1fOkXWYEugLHvUS455z8SHd0NvDa9O9o
    mS46X9UKuXFK+45Fd9Fa4gauOAbBHhJSUCMlLsknxgfJZVIZXQMtlONaS6JMGLsOBWsb
    kDoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791201271;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ck8/UTx5CCxvmelK4jSyBm8N+nwsqu5R9ItOFQBEQH8=;
    b=e+ktHQR7CNoduKojQMY3gFx5Kn1ucuyGEjn1rTQo0Mjk9lpZk9Fo8IdY4XHsDuegmc
    uA0GSAxwwB59aCLULGrr4+fkMYXRiUPS1qV+AiHdhtDF0QNXehMWxGMDPvttDwxRV8PE
    3q6SJibcRN+E7rLe2HN95j5lY07ntV4/caRcRakCGqlz9QPz9JGczaufzs1/BunwC52t
    e9ggp/BKZwMA3KD5vMM6mQJq2ZvVMoKk2mhkHa5jkffqnPe3wgfjQpk2VlXm5Wws/SzN
    KT3Cb1Jg3NrkhXiui0Ma/zDbjzNJlcpgIoQ03jxp3tmk4TPk3NnvIhzsdH9O/f9ONyXE
    jhJw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791201271;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ck8/UTx5CCxvmelK4jSyBm8N+nwsqu5R9ItOFQBEQH8=;
    b=GQJ/rxyYVHg2reXyHUkB1teDDR55KuAGVsA5mYGvlFb1DGbIr0/tm2yWOGiOb8XqqF
    5kqK02aTX6penZxg/9c7SyIRsH1O92TPkpeSuVeqwsH1HhhyPbowXm7NMMP+RjO+jV+h
    RHLbQmccyJ8rSIupA/IxJh0wvjblTFI2NE7GvnHkCeF/LLcAXRdcBwI1zuhqpi4i1Lx4
    6FkXYFgqvU7bYynUvPMCpWG2coLC2Axu0zIL+Lo9cRDHrYwRMRRcD88h6yTx8J1b3O9v
    IMo9MYPDyFmP5BjfbnB/g10k0MdSF6z0J6DsKnhw9WiJBiBMUPpcB433busY8BzvqxbR
    SCgQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791201271;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ck8/UTx5CCxvmelK4jSyBm8N+nwsqu5R9ItOFQBEQH8=;
    b=BjTpxYHYhclzhR1ha2zFbnNNVuuyZTHA9ELB+Ty4toBOFsrKsSAZR8q3EgQI7FgF2H
    KKPhn2W9H0Z6dptrzKBg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.163]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c295BsTQ3d
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 5 Oct 2026 13:54:29 +0200 (CEST)
Message-ID: <1912caf84d99bc2388960c907184f06689806ee6.camel@iokpp.de>
Subject: Re: [PATCH 6.18.y] scsi: ufs: core: Re-arm the device command
 completion before submitting
From: Bean Huo <beanhuo@iokpp.de>
To: alice.chao@mediatek.com, stable@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, 
 bvanassche@acm.org, avri.altman@sandisk.com, alim.akhtar@samsung.com, 
 wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 peter.wang@mediatek.com, chun-hung.wu@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com, naomi.chu@mediatek.com,
  ed.tsai@mediatek.com
Date: Mon, 05 Oct 2026 13:54:28 +0200
In-Reply-To: <20260915052638.459390-1-alice.chao@mediatek.com>
References: <20260915052638.459390-1-alice.chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-15 at 13:26 +0800, alice.chao@mediatek.com wrote:
> From: Alice Chao <alice.chao@mediatek.com>
>=20
> Commit 20b97acc4caf ("scsi: ufs: core: Fix a race condition related to
> device commands") moved the device management command completion into
> struct ufs_hba, initialized once by ufshcd_init(), and dropped the
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->dev_cmd.complete =3D=
 NULL;
>=20
> assignments that used to make ufshcd_compl_one_cqe() discard completions
> the submitter had already given up on. Nothing replaced them, so the
> completion is never reset between two device commands:
>=20
> =C2=A0 Task A (device command submitter) IRQ (tag =3D=3D hba->reserved_sl=
ot)
> =C2=A0 --------------------------------- ------------------------------
> =C2=A0 ufshcd_read_desc_param()
> =C2=A0=C2=A0 ufshcd_query_descriptor_retry()
> =C2=A0=C2=A0=C2=A0 __ufshcd_query_descriptor()
> =C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_exec_dev_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_issue_dev_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_send_command()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_wait_for_dev_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_for_completion_timeout()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* times out, done =3D=3D 0 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_clear_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* returns 0, no effect */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EAGAIN
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufs_mtk_mcq=
_intr()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshc=
d_mcq_poll_cqe_lock()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ufshcd_mcq_process_cqe()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ufshcd_compl_one_cqe()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /* lrbp->cmd =3D=3D NULL */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 complete(&hba->dev_cmd.complete)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /* done: 0 -> 1 */
> =C2=A0 ufshcd_query_attr_retry()
> =C2=A0=C2=A0 ufshcd_query_attr()
> =C2=A0=C2=A0=C2=A0 ufshcd_exec_dev_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_issue_dev_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_send_command()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_wait_for_dev_cmd()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_for_completion_timeout()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* returns at once, done: 1 -> 0 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_dev_cmd_completion()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* response UPIU not written yet */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL
>=20
> Task A then rejects what it reads out of the response UPIU:
>=20
> =C2=A0 ufshcd_dev_cmd_completion: Invalid device management cmd response:=
 0
> =C2=A0 ufshcd_dev_cmd_completion: unexpected response in Query RSP: ff
>=20
> The skew does not self-correct. On a UFS 4.0 controller in MCQ mode it
> persisted across more than a thousand consecutive device commands,
> failing every descriptor and attribute read until the link was reset.
>=20
> The controller can still complete the timed-out command because in MCQ
> mode ufshcd_clear_cmd() only issues an SQ cleanup (SQRTC.ICU), which
> shows the command left the submission queue but not that a CQE is not
> already posted. The MCQ path also skips the hba->outstanding_reqs
> re-check that the SDB path does, so it returns -EAGAIN with the
> completion still armed.
>=20
> Re-arm the completion in ufshcd_issue_dev_cmd(), immediately before
> submitting. All submitters - ufshcd_exec_dev_cmd(),
> ufshcd_issue_devman_upiu_cmd() and ufshcd_advanced_rpmb_op() - reach it
> holding hba->dev_cmd.lock, so no extra serialization is needed.
>=20
> This narrows the window rather than closing it: the CQE only carries the
> tag and every device command uses hba->reserved_slot, so a late
> completion is still indistinguishable from the expected one. It no
> longer spans the idle time between two commands.
>=20
> No mainline commit: commit 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()") moved this path onto the block layer and
> removed struct ufs_dev_cmd::complete and ufshcd_wait_for_dev_cmd(). Each
> device command now waits on its own request via blk_execute_rq(), so
> mainline has no shared completion to skew. That refactor is not a
> reasonable stable backport; this is the minimal alternative.
>=20
> Affected versions: v6.15 through v6.18, i.e. the kernels that carry the
> commit named in the Fixes: tag but not the mainline rewrite above.
>=20
> Fixes: 20b97acc4caf ("scsi: ufs: core: Fix a race condition related to de=
vice
> commands")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alice Chao <alice.chao@mediatek.com>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 9 +++++++++
> =C2=A01 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 87578e8824d2..003fa8af4f4d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3312,6 +3312,15 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hb=
a,
> struct ufshcd_lrb *lrbp,
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int err;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * A device command that timed=
 out may still be completed by the
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * controller later on. hba->d=
ev_cmd.complete is shared by all device
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * commands, so re-arm it here=
, immediately before submitting, to keep
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * such a late completion from=
 being mistaken for the completion of
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * this command.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0reinit_completion(&hba->dev_cm=
d.complete);
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_add_query_upiu_tra=
ce(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_send_command(hba, =
tag, hba->dev_cmd_queue);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0err =3D ufshcd_wait_for_d=
ev_cmd(hba, lrbp, timeout);
> --


I have one question:

The late CQE can come after the re-arm:

timeout -> cleanup -> retry B -> re-arm -> send B -> A's CQE arrives, and t=
hen B
is woken up early and fails, if B's own CQE in turn comes after C's re-arm,=
 C
fails the same way, and C may even read B's response as its own.=C2=A0

Whether this stops depends on device latency against our retry path, not on=
 the
patch.=C2=A0

The root cause is that all device commands share hba->reserved_slot and the=
 CQE
carries only the tag. Since a successful SQ cleanup must post an ABORTED CQ=
E,
could the MCQ timeout path wait for and consume that CQE before=C2=A0return=
ing -
EAGAIN?=C2=A0

does this patch only covers a late CQE arriving while no device command is =
in
flight. Did you test it with injected timeouts to see whether it recovers?


Kind regards,
Bean
