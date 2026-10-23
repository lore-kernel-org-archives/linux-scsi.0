Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751761;
	b=T6MvlUjd3U1h9RWCVsWc3gL9ZIfKBwV6+mvf7DrJTdjFhWhJ7Z6QZcxB4ZMvPYvy2MZG
	 HsIVHgaI4648FMMbvIniMYn9tRzraGE7rLtUh+Xxdj2Haqo4HAcfY7fQ+50kYaMlTcCMS
	 prP6P5E/LFMGHWFyAdpEpS8Q68zwmREV25X99A2XhOOdlo8HD0En/1F+5wjrdfUFuIcw3
	 pKJeGxMH4w/Spp9myoS7ofKM9scA77BVywuakyBMDvfMVuaxq6qgAgTccQUU5hi9L8RNR
	 M9Z5KTdT1uPaU011Uojwj/TaQie1jnWud9Lau7FqkEpq5/0Q9zziSQNDnleWZQPlzpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751761;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p9vhZvbKCrUpEYqVvnGnRQEYJTaWezBPvqITPj502kw=;
	b=npjCGvkW5VFhgEfnfO6JRNEAOjW8bke1RcYmVEAd3Z4AREF551eYo/muV2JmxqFpe30j
	 Z/lPOa22pdwi3fjqZXsphWkxeWL1Tok/Urs4MeXizmTQB5WvpKtBJyqbX2XAlDfxcyeVd
	 TCd8xtnnRuwIa5KJsv5jqKGqi6RSanK0/3YWrTxG4ZfbwNpYyvfI+akRqIiJ7qORA+gMc
	 kf3jZbr1EbZD33Qi/B3R1UPKUvq7pTUhZWb3YXIAsKci3py9bgKu0Ia50pZHSh2QILz7x
	 V6VEIr9GWy8izWwd95xPw2tkw2KN4fs/trA1CvRuOD/XSscxPP6Z6+wu0Lfvyzlc38A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NA2nb8N7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19935606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NA2nb8N7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEE41F01825;
	Fri, 23 Oct 2026 10:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751760;
	bh=p9vhZvbKCrUpEYqVvnGnRQEYJTaWezBPvqITPj502kw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NA2nb8N7LWre8ut4QBzQAdlvI6SKaBhdkCyCqvcc28ezBATrcGygr9Aopva/4ZSwj
	 YA650SO5a9FEC0pq9L0dNyFemOofRB9Zyr145ab6tuJVdtfLHsWKpnuC4/TgqY1VHC
	 hSLTsE+n9sKVZ2g4pyVJhy94s3/1m9WP19Ko2A/kj5pP2VBrFNbTocLDKdgHm/VZdz
	 EBQJ/CkBk7Hv+BuYQ1hOhjQXI4lOaXGu/424TmD46pic+y0OI3W2zyQo65/qszqgaB
	 6IH58ASjYVbZyhabyj762XEwMHaneUbGmrXDH2YgVvPS+Q8/tQTLMKph00unG/W4ab
	 weK2DnT0kMa9A==
Message-ID: <sashiko-outbox-182695@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/13] scsi: qla2xxx: Update few AENs for 29xx
 handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-3-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:36:00 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: qla2xxx: missing IS_QLA29XX() in qla24xx and mpi RAM dump =
helpers
- [Medium] scsi: qla2xxx: unloaded fwdt[1] template breaks 29xx MPI dump in=
 qla2x00_async_event()
--

commit a55d0fe512b854062fc6be4342178f19e1073032
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update few AENs for 29xx handling

This commit updates qla2x00_async_event() so that QLA29XX adapters follow t=
he
same handling as QLA27XX and QLA28XX adapters for several asynchronous even=
ts,
including triggering MPI and RISC firmware dumps on MBA_SYSTEM_ERR and
MBA_IDC_AEN.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 63b70d4abbf02..7bae26d4404c2 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1443,7 +1443,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rs=
p_que *rsp, uint16_t *mb)
>  		vha->hw_err_cnt++;
> =20
>  		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
> -		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		    IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  			u16 m[4];
> =20
>  			m[0] =3D rd_reg_word(&reg24->mailbox4);
> @@ -1459,7 +1459,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rs=
p_que *rsp, uint16_t *mb)
>  			    "ISP System Error - mbx1=3D%xh mbx2=3D%xh mbx3=3D%xh.\n ",
>  			    mb[1], mb[2], mb[3]);
> =20
> -		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
> +		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) &&
>  		    rd_reg_word(&reg24->mailbox7) & BIT_8)
>  			ha->isp_ops->mpi_fw_dump(vha, 1);

[Severity: Medium]
Can ha->isp_ops->mpi_fw_dump(vha, 1) succeed on QLA29XX under the default
flash firmware load path (ql2xfwloadbin =3D=3D 0)?

When qla29xx_load_risc() loads firmware from flash, it calls
qla29xx_load_fw_template(), which hardcodes templates =3D 1 and only popula=
tes
ha->fwdt[0].template:

drivers/scsi/qla2xxx/qla_init.c:qla29xx_load_fw_template() {
    struct qla_hw_data *ha =3D vha->hw;
    struct fwdt *fwdt =3D ha->fwdt;
    uint templates =3D 1;
    ...
}

Because ha->fwdt[1].template remains NULL, calling qla27xx_mpi_fwdump() via
ha->isp_ops->mpi_fw_dump(vha, 1) during MBA_SYSTEM_ERR (when mailbox7 BIT_8=
 is
set) or MBA_IDC_AEN will hit the missing template check and bail out:

drivers/scsi/qla2xxx/qla_tmpl.c:qla27xx_mpi_fwdump() {
    ...
    struct fwdt *fwdt =3D &ha->fwdt[1];
    ...
    if (!fwdt->template) {
        ql_log(ql_log_warn, vha, 0x02f6,
               "-> fwdt1 no template\n");
        goto bailout;
    }
    ...
}

In addition, when template entries execute for QLA29XX,
qla27xx_fwdt_entry_t263() in drivers/scsi/qla2xxx/qla_tmpl.c copies request
and response queues using sizeof(*req->ring) and sizeof(*rsp->ring) (64 byt=
es)
rather than qla_req_entry_size(vha->hw) and qla_rsp_entry_size(vha->hw) (128
bytes on QLA29XX):

drivers/scsi/qla2xxx/qla_tmpl.c:qla27xx_fwdt_entry_t263() {
    ...
    qla27xx_insertbuf(req ? req->ring : NULL,
        length * sizeof(*req->ring), buf, len);
    ...
    qla27xx_insertbuf(rsp ? rsp->ring : NULL,
        length * sizeof(*rsp->ring), buf, len);
    ...
}

Should qla29xx_load_fw_template() load the secondary MPI template into
ha->fwdt[1] and should qla27xx_fwdt_entry_t263() use the dynamic entry size
helpers so that QLA29XX dumps are not aborted or truncated?

[ ... ]

> @@ -1998,7 +1999,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rs=
p_que *rsp, uint16_t *mb)
>  		break;
> =20
>  	case MBA_IDC_AEN:
> -		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  			vha->hw_err_cnt++;
>  			qla27xx_handle_8200_aen(vha, mb);

[Severity: Medium]
When MBA_SYSTEM_ERR or MBA_IDC_AEN (via qla27xx_handle_8200_aen()) triggers
qla27xx_mpi_fwdump() or qla27xx_fwdump() on QLA29XX, does executing template
entries T272 (ENTRY_TYPE_RDREMRAM) and T262 (ENTRY_TYPE_RD_RAM) byte-swap a=
ll
dumped RAM words?

qla27xx_execute_fwdt_template() dispatches T272 to qla27xx_dump_mpi_ram() a=
nd
T262 to qla24xx_dump_ram(). Both helpers in drivers/scsi/qla2xxx/qla_dbg.c
check only IS_QLA27XX(ha) || IS_QLA28XX(ha) to skip swab32():

drivers/scsi/qla2xxx/qla_dbg.c:qla27xx_dump_mpi_ram() {
    ...
    ram[i + j] =3D
        (IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
        chunk[j] : swab32(chunk[j]);
    ...
}

drivers/scsi/qla2xxx/qla_dbg.c:qla24xx_dump_ram() {
    ...
    ram[i + j] =3D (__force __be32)
        ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
         chunk[j] : swab32(chunk[j]));
    ...
}

Should both of these checks also include IS_QLA29XX(ha) so that MPI and RISC
RAM words in QLA29XX template dumps are not byte-swapped?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D2
