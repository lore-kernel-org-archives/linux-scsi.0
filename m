Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789850;
	b=p4jAeK56wXuJeD+t2Flz8mwUz7DFjScupE94SohJt2gnY9Xx1dNUvcf6YTcFNAYvL4SY
	 40wvFMQO+cRwOOvZdNNYRz33PSfN2wRhN+OQObSRnEMZmsZLljkk3d31d5WWlc74NwQX0
	 kk4NN+xyC/Kxjne5+oMm7/vwUHDEeZbjwY0uykl+3oHU1N1OC51+AWWOwIChADGqtJx4x
	 zXhaqeSZi+LbelUmNV3QpW69uja7N6Kh62DB1peLeClX/f3HTYZYxq8PdSgUBAn32DhJw
	 g7K4D7JBs+R01b/ZmRwpHYPwjKYzcsIknAmzKHnSPx79us0624eB3T1z46U4AX6E6sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789850;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EOQf/4BLz0OqcTzzrUz2ZMCSsYIeIRLwEfryDUaVkd4=;
	b=w1yVEnWqGv8uZi6NoG/mbkgbbHJEyyetAW8aUR1sjGomYTiGBDYL7Ok/B6RAmCxM1SKY
	 RcIipr+6Ju7tgCzQdbRB02UuwHJSNFMsBz5mazs0EJXdjbf+Nuptx+oG7LeY1KzaCK3lZ
	 CNAkzkvyXqqkRn1zkjfxNIYpYQFz9AqJoxeV1k+3YPVTuEQSxNDPUhVviJyjeacnmz1Nm
	 +jBO55RpqJWrJMrwa4wYc/gKucfaEmPnPBBd3E3nRvvyQWo6ZkVW7m4cpv5K0cjvS6OxE
	 D5EL0Ukf2UBYz+mTmIM+PGKUnlVvPH3WRoHiGo8AOsTXmaphzcZ0W+LzK4SCopoU2ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cR8bWZpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EBF606A31F;
	Mon, 16 Nov 2026 00:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cR8bWZpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A081F000C4;
	Mon, 16 Nov 2026 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789849;
	bh=EOQf/4BLz0OqcTzzrUz2ZMCSsYIeIRLwEfryDUaVkd4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cR8bWZpyUtdlx0wU9JniFGb8WDI93He9rvxvzragzjQBeRDU4ukd4oh4V8YuHM05X
	 3TNOG0elT40BLZb5/g4gEmKGWIHjG8oT2zS+I1OlGD/wrYnj0D10MOolhRZiWnJ8LL
	 pKOHUCEvTJEnwmtaISwOZDMdpoXqltTQWE5c6FHNPJyhgwwAJpr6fIH/n4HzQRGH0Q
	 YTts6BBspv50tH9veCiIEHSvpA8WPOffFuE28Wcw+QORRuouS06J7qcBAAUxw+gmgI
	 QPmC1ugqCLtjf4VjeGop4mu+mvacefGoNRoMDjnq0+OHDJmXk4SRlYrBNiHGD5Sk1k
	 o8OxnrVDz8TAQ==
Message-ID: <sashiko-outbox-215967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 14/18] scsi: target: uring: Handle WRITE SAME
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-14-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-14-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:44:08 +0000
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
- [High] scsi: target: uring: missing payload checks in
  tcmur_execute_write_same()
--

commit 194f0b295175d883a8fb6c1f553cf215c122630e
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Handle WRITE SAME

This commit adds WRITE SAME support to the target_core_uring backend via a
new TCMUR_OP_WRITE_SAME operation.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index 366c5e9820956..42283a1ae1512 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c
[ ... ]
> @@ -295,6 +297,16 @@ static sense_reason_t tcmur_execute_unmap(struct se_=
cmd *se_cmd, sector_t lba,
>  	return tcmd.status ? TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE : 0;
>  }
> =20
> +static sense_reason_t tcmur_execute_write_same(struct se_cmd *se_cmd)
> +{
> +	u32 block_size =3D se_cmd->se_dev->dev_attrib.block_size;
> +
> +	return tcmur_submit(se_cmd, TCMUR_OP_WRITE_SAME,
> +			    se_cmd->t_task_lba * block_size,
> +			    (u64)sbc_get_write_same_sectors(se_cmd) * block_size,
> +			    se_cmd->t_data_sg, se_cmd->t_data_nents);
> +}

[Severity: High]
Can tcmur_execute_write_same() submit a TCMUR_OP_WRITE_SAME descriptor
whose data_len is 0 or larger than block_size?

Because sbc_parse_cdb() does not set SCF_SCSI_DATA_CDB for WRITE SAME,
target_cmd_size_check() does not reject commands when an initiator sends no
data buffer (leaving t_data_sg NULL and t_data_nents 0) or a transfer
length larger than one block, nor when protection information sets
se_cmd->prot_op.  tcmur_submit() then sets desc.data_len to 0 or
se_cmd->data_length, breaking the UAPI guarantee that data_len is one block
and causing a userspace server to spin forever on a zero step or overflow a
single-block buffer.

Should tcmur_execute_write_same() validate se_cmd->prot_op,
se_cmd->t_data_nents =3D=3D 1, and se_cmd->t_data_sg[0].length =3D=3D block=
_size
the same way fd_execute_write_same() and iblock_execute_write_same() do?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D14
