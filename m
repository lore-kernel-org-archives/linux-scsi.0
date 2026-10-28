Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793194461;
	b=O3IFN71QjUe38ltqgsQWVm8m4KVB6qfq0whrzlx0pgn3decT6sRFHRaqhzh2as9vrPhf
	 gtzFK/91MC3lr2zdECPSQJ8Lu+XmtDxNuIB1km3TRyxsVPOWAP66EPCcsXmfxLJDYfkkG
	 IkF7I6bUeTj4sBt3/Pjv8JZv6B1s8XVuaBvEJ7THOiW7/skbkV3Z5dSKa4TY+Bc7mwOBU
	 kOlMCIvxLV0d/KHMKttQGxRgio36h2ZvZB8nS/uwkH30bmtp+xmrGeSUXBkrs8Ka49FIn
	 LQ95aVdcOYpvxJLmQadoR26iiMPUn7G4G1AP475H6r8y9o+Bv7vgqAUOF2UXDLIn4Xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Ee4OtoDdUVVMPj/wc6rKMnSoGu+WOHUA0z+EnvP+fWM=;
	b=dyXe6uVXDMxmFczNoRGJcyzRmlSY2VKN27ZMQ/4z4KtQAm1hxNrwwrAFYNiOQx4XMcTk
	 +F0CO1sMQcVO4bSmQRQDRJVpDIgzC4sOgCrhzhxfAZ0KKBQM1QOWA1QO6di2cSurUldnD
	 aJMdZ3lJajwd15BA2cwhSem6rzy1QOhdZTwsPFXJFbzHRNxkoyBtiH5m2+kVXCNRycU3V
	 5cAg4rCCEyBq6gHOxEWYiez8Ke4n5zNvGqAwAmyztKa0RhHhYNcDDWGyzA17UJqqF3VlW
	 yRKg30vbPVA0WniUEpfiGIA5s2kf4KhWa4lVwdcuuZMvV5GV2Un7LpXzCPg9hZjrxLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=jOdl6IAy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61684606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 13:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61684606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=jOdl6IAy
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4677aad67bso108524766b.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 06:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793194459; cv=none;
        d=google.com; s=arc-20260327;
        b=dXJdYN/g/R5UFKE2hEHoSy5N2MOa+xcZsd157LyGpti9v3vy77NFJKG4+57d2bnX+N
         uzmjyrsXqgdeEBLkyNgfpnPDOv691CnxRwu+YSwZUVY5psBdfRhfU2hxwVyxWOCrdTje
         Jf3KHpa5BLm03vgj+6FOcP6M/yvBXJufCE0HHsPmv2raN2cqmNgvUnqyYUgRnIEkllST
         y+YEa5dr6VnxHkICagtEI7vaLiD4zj8C99vg1xa9SfYwxPL5GklLG+HVvBaMrq/6JgmZ
         +/YFLrK5gIFInV+anEEACDszwtPOs3sLItNQS8QrcNjCdHyDaBVG/j7wUOddwppz54Ab
         8g4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ee4OtoDdUVVMPj/wc6rKMnSoGu+WOHUA0z+EnvP+fWM=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=bsklaIvIJhMhViPxrpEaFyOkHCLlZdhecC3bICTRf3k4BwDAQZ9x9CWFCqgyIxCYNV
         2RQdQyP0qsW30iK851LoiEdyq3iDr3VqXVEA2qwqHu4C4G+yBg3DxgV0/D9TgBkYVpT/
         0yBok4x9b2bBf4biOUlOROsyM+4WGJxT7vFFl7FtSSd3a7gzltZy2ooISaO2l2MI++3h
         10DU8W7THHnMJ40/KK0EaJhei3SOQPrUn/DBj2NlGq1eIOxyufzKXyyQ6eiGw8mPMfnr
         QlGwhYzjNeUlhvFJCOI+xAhk5BnLGfyp61GpbMUBtw45o50n8Y/+aRZb956zfjIB2DpJ
         D0zQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793194459; x=1793799259; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ee4OtoDdUVVMPj/wc6rKMnSoGu+WOHUA0z+EnvP+fWM=;
        b=jOdl6IAyzXbXUbv44SywYV9QSdrBLgZNl7M0RuAA1vSSmKpLW5xneO3yvAXDkYLEHV
         eRA+3mnIYnc1ppFHTgPCXI9lNI+3c7e+j4Bd7DIQTx0zYUEB5XXaHgYnEnclq5W7TPUl
         LGRH8H//FM0ZN8roZ+50vZT+u5omdRaiQGbKIpql6MaSDZIRwyzF0sLtNMpHEeCfdSi3
         U7j0dFD1QRiAUH9XXohyYqfeHvaDiZj/TJ9m5LYwAebdbvWUfN8yO0cIuWQmanz4D2P9
         OynjpmJS9els5kM6YkSrVxCR7etD1MaOFEQChlZZMYvCUyRLC3kJ9uQXgcaXQIr8w6iD
         Z1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194459; x=1793799259;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ee4OtoDdUVVMPj/wc6rKMnSoGu+WOHUA0z+EnvP+fWM=;
        b=zt9zjC2vvgZgYT9NHennbmkDrOKAckVm9vNApLGGTHMnojrMenSumMhQX2atPtm/Si
         xP0oCRlY48yi0OpKwmURnYTvhApTByIbiZWZ87gwsfDaRGa6vtGZpQf7KCg2QN1xvzXy
         NMAnDhW55xjSNsz+kg5gVSYOfcujrpzQI4eQiIFOIzORwSBItxcy17s9htolGSzpLgv/
         czjjSEIEFbJS/f1N7jKh3T/OKLnO0XGE49HbNtdPCnUfRKQmg6taZ/9nljPWXl5JEa7x
         PSrGebRFeuZMVwJ0EzF5oRyb/IbO5+f5KelwyiaVlUx850RsCBbuS/dIjWGPUnD9XDB7
         U1rA==
X-Gm-Message-State: AFq9FYL2zfckyApPWBocZzlN94bSD9S5279/dJOeu49X+I+MMMwIjfD8
	tiO1zNA3g9nopAG9jtJiybwmeYu70tI2B+AdDac3WO8zQ3UqHEnyA1pIMkqnXlWck3jBBlY0StM
	7UcrBkeb/7fu2U+rjVox5TupN14A/nO3NnTMSTsAtEA==
X-Gm-Gg: AYBFou2+2WbeYBaMyqQgeadVxb/5Tca70kBExGE/vEqHtf9UVw3O3BuvB7xmE5yctWU
	HJneY3pxbW4YVR3iolT/FBxyEOg8G2FDdCPggbMppkBBs2vSJi2vmgaEcB1rEBOJj+sqn2QXpLR
	5vp4a90ZM8E0c1WtFjbRiyFmN7Od5ocYX92yMkn5rQRaMIJQxQK+FsYW7KOFlITqdtFK4FWesLu
	gPe3SF14z2fGMO9w6L/4dNX4Pi677jHfJX0usqyl1/kr1YE/BmKusBfJ0JPdyNjq8i8tmJKhgoW
	YFImr4B1onU/NZNo/OW+7RWeUatzcEmUPjS454H4hvwT3OhF4/ptFLTzw03gwAyZV+ecf9M/g16
	pNyjuGhw9VXuf7MaPzKfuSgmG17SAEiUmknJvxoRic2UStmV46HPS8sCdxRhkDjlCc4Udi3pJhU
	PrMCuDZs+QGrbT2Gc=
X-Received: by 2002:a17:907:60d1:b0:c31:9a1c:de76 with SMTP id
 a640c23a62f3a-c49bdf389ccmr208900966b.14.1793194458590; Wed, 28 Oct 2026
 06:34:18 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net> <sashiko-outbox-187901@kernel.org>
In-Reply-To: <sashiko-outbox-187901@kernel.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Wed, 28 Oct 2026 17:34:01 +0400
X-Gm-Features: AclHuK84rdq1eh77fj4l7hk6VSAzgGvuEl-QASfPeiofUA5FndtFXoShRb4A-Pk
Message-ID: <CAKTNdwEGr-VSWUSPOQZO_Pr-i=Wm+jMaoHneMjmUbMJmihUJQw@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN devices
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:17=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Medium] scsi: ufs: unhandled broken OCS quirk in ufshcd_clear_unit_att=
ention()
> - [Medium] scsi: ufs: core: ufshcd_issue_devman_upiu_cmd() hardcodes lun =
0 in lrbp
> --
>
> commit 02e1f4aa450245801c780ec99fe1072a3f8e77c3
> Author: Alexey Charkov <alchark@flipper.net>
>
> scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN devices
>
> This patch adds a device quirk for BIWIN UFS devices (models starting wit=
h
> BWU2A05) to clear pending power-on unit attention conditions across all
> logical units after a host reset and restore by issuing a TEST_UNIT_READY
> command via the device management slot.
>
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index ee643830a57a2..d52275a813fd3 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
>
> [ ... ]
>
> > @@ -8265,6 +8268,55 @@ static void ufshcd_process_probe_result(struct u=
fs_hba *hba,
> >                         hba->curr_dev_pwr_mode, hba->uic_link_state);
> >  }
> >
> > +/**
> > + * ufshcd_clear_unit_attention - clear the power-on UNIT ATTENTION of =
each LU
> > + * @hba: per adapter instance
> > + *
> > + * Send a TEST UNIT READY to each logical unit to clear the power-on U=
NIT
> > + * ATTENTION left by a device reset, for devices that keep reporting i=
t to
> > + * WRITE commands instead. Receiving the UNIT ATTENTION is what clears=
 it, so
> > + * only transport failures matter.
> > + *
> > + * Use the device management slot rather than the logical units' reque=
st
> > + * queues: those are blocked during error handling, and during a runti=
me
> > + * resume of the device W-LU its runtime suspended consumers cannot ta=
ke
> > + * requests until it has resumed.
> > + */
> > +static void ufshcd_clear_unit_attention(struct ufs_hba *hba)
> > +{
> > +     struct utp_upiu_req req_upiu, rsp_upiu;
> > +     struct scsi_device *sdev;
> > +     int err;
> > +
> > +     shost_for_each_device(sdev, hba->host) {
> > +             if (scsi_is_wlun(sdev->lun))
> > +                     continue;
> > +
> > +             req_upiu =3D (struct utp_upiu_req){
> > +                     .header =3D {
> > +                             .transaction_code =3D UPIU_TRANSACTION_CO=
MMAND,
> > +                             .lun =3D ufshcd_scsi_to_upiu_lun(sdev->lu=
n),
> > +                             .command_set_type =3D UPIU_COMMAND_SET_TY=
PE_SCSI,
> > +                     },
> > +                     .sc.cdb[0] =3D TEST_UNIT_READY,
> > +             };
> > +
> > +             ufshcd_dev_man_lock(hba);
> > +             err =3D ufshcd_issue_devman_upiu_cmd(hba, &req_upiu, &rsp=
_upiu,
> > +                                                NULL, NULL,
> > +                                                DEV_CMD_TYPE_SCSI,
> > +                                                UPIU_QUERY_OPCODE_NOP)=
;
>
> [Severity: Medium]
> When ufshcd_clear_unit_attention() sends a DEV_CMD_TYPE_SCSI command to a
> non-zero LUN, ufshcd_issue_devman_upiu_cmd() still passes a hardcoded LUN=
 of
> 0 to ufshcd_setup_dev_cmd():
>
> drivers/ufs/core/ufshcd.c:ufshcd_issue_devman_upiu_cmd() {
>         ...
>         tag =3D scsi_cmd_to_rq(cmd)->tag;
>
>         ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
>         ...
> }
>
> This leaves lrbp->lun set to 0 even though req_upiu.header.lun targets a
> non-zero LUN.
>
> If the command times out during error recovery (for example via
> ufshcd_err_handler() -> ufshcd_reset_and_restore() ->
> ufshcd_host_reset_and_restore() -> ufshcd_clear_unit_attention() when
> hba->pm_op_in_progress is false), scmd_eh_abort_handler() invokes
> ufshcd_abort() -> ufshcd_mcq_abort() -> ufshcd_try_to_abort_task(), which
> uses lrbp->lun to issue UFS_QUERY_TASK and UFS_ABORT_TASK:
>
> drivers/ufs/core/ufshcd.c:ufshcd_try_to_abort_task() {
>         ...
>         for (poll_cnt =3D 100; poll_cnt; poll_cnt--) {
>                 err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUER=
Y_TASK,
>                                           &resp);
>         ...
> }
>
> And ufshcd_clear_cmd() -> ufshcd_mcq_sq_cleanup() also uses lrbp->lun to
> build the nexus written to REG_SQCTI:
>
> drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_sq_cleanup() {
>         ...
>         /* SQCTI =3D EXT_IID, IID, LUN, Task Tag */
>         nexus =3D lrbp->lun << 8 | task_tag;
>         opr_sqd_base =3D mcq_opr_base(hba, OPR_SQD, id);
>         writel(nexus, opr_sqd_base + REG_SQCTI);
>         ...
> }
>
> Should ufshcd_issue_devman_upiu_cmd() pass req_upiu->header.lun instead o=
f 0
> to ufshcd_setup_dev_cmd() so that task abort and MCQ queue cleanup target=
 the
> right LUN?

Makes sense, I'll implement this in v2 after waiting for other feedback.

> > +             ufshcd_dev_man_unlock(hba);
> > +             if (err) {
> > +                     dev_warn(hba->dev,
> > +                              "TEST UNIT READY to LUN %llu failed: %d\=
n",
> > +                              sdev->lun, err);
> > +                     scsi_device_put(sdev);
> > +                     break;
> > +             }
>
> [Severity: Medium]
> What happens here on host controllers with UFSHCD_QUIRK_BROKEN_OCS_FATAL_=
ERROR
> (such as ufs-exynos)?
>
> When a logical unit has a pending unit attention condition, the device
> responds to TEST_UNIT_READY with a Response UPIU having header.response s=
et
> to TARGET_FAILURE and header.status set to SAM_STAT_CHECK_CONDITION. On
> controllers with UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR, hardware reports
> OCS_FATAL_ERROR in the UTRD/CQE whenever the Response UPIU has a non-zero
> response or status field.
>
> For normal SCSI commands, ufshcd_transfer_rsp_status() overrides ocs back=
 to
> OCS_SUCCESS:
>
> drivers/ufs/core/ufshcd.c:ufshcd_transfer_rsp_status() {
>         ...
>         if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
>                 if (lrbp->ucd_rsp_ptr->header.response ||
>                     lrbp->ucd_rsp_ptr->header.status)
>                         ocs =3D OCS_SUCCESS;
>         }
>         ...
> }
>
> However, ufshcd_issue_devman_upiu_cmd() uses a reserved device management
> command (!ufshcd_is_scsi_cmd(cmd)). In ufshcd_compl_one_cqe(), the reserv=
ed
> command path bypasses ufshcd_transfer_rsp_status() and leaves
> lrbp->utr_descriptor_ptr->header.ocs as OCS_FATAL_ERROR, which
> ufshcd_issue_dev_cmd() then returns directly:
>
> drivers/ufs/core/ufshcd.c:ufshcd_issue_dev_cmd() {
>         ...
>         rq->timeout =3D timeout;
>         sts =3D blk_execute_rq(rq, true);
>         if (sts !=3D BLK_STS_OK)
>                 return blk_status_to_errno(sts);
>         return lrbp->utr_descriptor_ptr->header.ocs;
> }
>
> Wouldn't this cause ufshcd_clear_unit_attention() to see OCS_FATAL_ERROR =
on
> the first LUN that reports unit attention, log a warning, and break out o=
f
> the loop before clearing the remaining LUNs?

It probably will, but this failure mode requires a BIWIN
BWU2A05-series UFS device on an Exynos host controller, which is not a
combination I have access to (I only have Rockchip RK3576 boards). I'm
not sure those even exist.

If anything, this should probably be fixed in the common
ufshcd_compl_one_cqe() function, not directly related to this patch,
because it would also affect similar pre-existing logic in the
Advanced RPMB flow.

Best regards,
Alexey
