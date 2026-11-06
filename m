Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927587;
	b=cZyBzoUj3+8EvIfGeXAe9FfTDc642Yq2hPrNRByNSW8faGZ7hf9R+cXZfUFocEES69/m
	 xMCuymcHx4jsIbNTN6GW5cc85m/ltBCfjL2QdeySYTszGi/Z2xpp4ZPcY+EgwrXFXCmn7
	 +MFrg44SR3UpKNloRuvuuFsJDtESfh6vbVbEwzffBlHO/jxDeZ7ae4gndWspkq/baQJUm
	 OBcX81XP9VnMHWcJcBxmi7DnkP8BzlX3S0Lyn6Km9QhJJVxyoaQ1/zIY5+fIFXSjV+fgr
	 Mk9WA2XDY52npI0JJ4AhAfbFK5QCBrQUK2wReWqOfdXU2CeHFK/ELC1yi8iIl9Ldqxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927587;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dVgHSuqDYRQ1XL5E/3l9azFjj/AjmX7vBjQaysMBknI=;
	b=YncbYM7IsycHI9ipGe1rZZ1mTlDql5aCIqoxnFkkM7fIsZXJBal3HzIWG5XclgH22HYP
	 k2G/cDFHZN9dzdBkbOeSp3CtcFQBBRD+HKVkKq0rWyA/t5PI0WnsfZrmfeWfqL33TtNL+
	 ekdWHVOWVt2q49Ud07gY31Bjyz7qWHQVRqcQGHk9XB9TqlZbjzKBONxe6ZL6OE3htnmrS
	 ULNR6VaJIodTzgzids12bxDZ/S/fGfDddQqFbJihHks/IVDdhMQW/u/QHxdfj8hd7uFKC
	 tb6A35B35Hf/igXjOAkm9cfACLKeKFCVGipGsFIyKJOWILP344fO88wr5Kqkf39qwFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqPbKqeL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC781606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqPbKqeL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4A21F0089F;
	Fri,  6 Nov 2026 01:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927586;
	bh=dVgHSuqDYRQ1XL5E/3l9azFjj/AjmX7vBjQaysMBknI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=kqPbKqeLjfd5Va8TQEPvyHt7NZUS3PArnUcWBemYDGDDI/eht3Ac96iyPy+npRd/c
	 2YeW+hKAvM5JYlgPvfu3X0giO2ULJLTM6mnUmp1ZWWo2pdCBaFfILTxAVf/wEHThkO
	 KljE+L/bP6F66Hxz0QOdoDDvVV4WArJWb+l9BdVkdY9T7Alb3tJVS0SGkJrTHd0ywW
	 3S5QBhWiuRJD/bWhb/ToEXOhJ+uR73htMJKShVKae5ABjpI8bfnMwxDLiekcis2m+f
	 +Mm9pZN+G8ppS01mE1pynX845HJqp3tzxF7lbuEy//lKD1oCUrAnng2d/QI5nKU+XZ
	 mS4f+1lHDfylw==
Message-ID: <sashiko-outbox-200489@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/37] scsi: mpt3sas: Clamp topology/IR event entry
 counts to EventDataLength
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:13:05 +0000
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
- [High] scsi: mpt3sas: u16 sz truncation bypasses u32 data_len clamp in mp=
t3sas_scsih_event_callback()
- [High] scsi: mpt3sas: out-of-bounds access when EventDataLength is smalle=
r than hdr_size
--

commit 6f4d73dbcac7a66faf3928944f8f083832f7bc3b
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Clamp topology/IR event entry counts to EventDataLength

This commit clamps NumEntries and NumElements in SAS topology, PCIe topolog=
y,
and IR configuration change events to the maximum number of entries that fit
within EventDataLength.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index a697200844078..4730e2d344f00 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -12212,9 +12212,21 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAP=
TER *ioc, u8 msix_index,
>  	}
> =20
>  	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
> -		_scsih_check_topo_delete_events(ioc,
> +	{
> +		Mpi2EventDataSasTopologyChangeList_t *topo_data =3D
>  		    (Mpi2EventDataSasTopologyChangeList_t *)
> -		    mpi_reply->EventData);
> +		    mpi_reply->EventData;
> +		u32 data_len =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;

[Severity: High]
Can a 16-bit truncation of sz later in mpt3sas_scsih_event_callback() bypass
this u32 data_len clamp and still overflow fw_event->event_data[]?

Here and in the MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST and
MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST cases, data_len is computed as a u3=
2,
whereas sz used for allocating and populating fw_event->event_data is decla=
red
as a u16 in mpt3sas_scsih_event_callback():

	u16 event;
	u16 sz;
	...
	sz =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
	fw_event =3D alloc_fw_event_work(sz);
	...
	memcpy(fw_event->event_data, mpi_reply->EventData, sz);

If EventDataLength is >=3D 0x4000 (for example, 0x4003), data_len is 65548,=
 so
max_entries is 8192 and an 8-bit NumEntries or NumElements value (up to 255)
is not clamped. However, sz truncates modulo 65536 to 12 bytes, so
alloc_fw_event_work(sz) allocates only 12 bytes for fw_event->event_data and
copies the header containing the unclamped NumEntries or NumElements. When
_mpt3sas_fw_work() later runs _scsih_sas_topology_change_event(),
_scsih_pcie_topology_change_event(), or _scsih_sas_ir_config_change_event(),
won't the loops over PHY[], PortEntry[], or ConfigElement[] read and write
past the end of fw_event->event_data?

> +		size_t hdr_size =3D
> +		    offsetof(Mpi2EventDataSasTopologyChangeList_t, PHY);
> +		u16 max_entries =3D 0;
> +
> +		if (data_len > hdr_size)
> +			max_entries =3D (data_len - hdr_size) /
> +			    sizeof(Mpi2EventSasTopoPhyEntry_t);
> +		if (topo_data->NumEntries > max_entries)
> +			topo_data->NumEntries =3D max_entries;
> +		_scsih_check_topo_delete_events(ioc, topo_data);

[Severity: High]
What happens if EventDataLength is smaller than hdr_size (for example,
EventDataLength is 0 or 1, so data_len < 12 for SAS/PCIe topology events or
data_len < 8 for IR configuration change events)?

When data_len < hdr_size, max_entries (or max_elements) is 0, but the event=
 is
not rejected before calling _scsih_check_topo_delete_events(),
_scsih_check_pcie_topo_remove_events(), or
_scsih_check_ir_config_unhide_events(), and execution continues to allocate
and queue fw_event with sz =3D data_len:

	sz =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
	fw_event =3D alloc_fw_event_work(sz);
	...
	memcpy(fw_event->event_data, mpi_reply->EventData, sz);

Because memcpy() only copies sz bytes into fw_event->event_data, fixed head=
er
fields such as ExpStatus/SwitchStatus (at offset 10), NumEntries (at offset=
 8),
or Flags (at offset 4) lie beyond the copied payload and, when sz is 0 or 4,
beyond the end of the fw_event slab allocation. When
_scsih_sas_topology_change_event(), _scsih_pcie_topology_change_event(), or
_scsih_sas_ir_config_change_event() (as well as the fw_event_list walks in
_scsih_check_topo_delete_events() and _scsih_check_pcie_topo_remove_events(=
))
access those header fields in fw_event->event_data, can this read out of
bounds past fw_event->event_data?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D9
