Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929025;
	b=HA8lJQEXPjs0RXzGkc3FQVFmG15YBi0XI36QVtpDlkUYHGB3K5fWI64OSZsPSAWEQNRF
	 UBxAHkG8ltoJ8m/RhMU2/Zj1gtIfgkvwcoB/NHyEbFlsoY6vrV6Kjn+aGI+KwIBWO3i0R
	 DhQ2o1Kp0LOaVuHeIPeHcLXAsgqtvGOYOig04XvTKzPHeTKYxI2Wn9CMnRzdeCd87P5kF
	 Djo9oL9QEYGKRP2G37BcqvjF4tFoVfZ+GiS5LVpMzjuhixplhQnGadoGcRo4jIwsVJ9ij
	 sQE+z0femh1MVsbp+mtvJFBXQ+W8la9cwjXUJQ6MoaRHU6lpIgOGFg4m7HYJstlTNcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zQ2jiz+69y5r398IPcaOMAC0gMh7O1pPCwViBsbhWys=;
	b=xCxgB/dOwGmSQfI4VSE6mz1hE3WBUXPjHXkmqSSJdgPMU1GcTEYtrOdA20DVGHjlT01M
	 2VmBik/cEMcXC9PvO6IJlLvylyKwuEJYwEG+A1vNbIhx6Jkgkapd1E1nzf8IVx7wVy1qh
	 r4sqZeHCXd+IyDW+MXtisyADo9Fzve6y9Hpp+7rf+N3hv0zbdHrAgDywIJ7ibIiI5lfpa
	 +AJLvSDBEdVKDBEQSXyqWyjIusIYV+32spP2S0bdD9f9YLldYsHipMe9O8z6xNsgx9YOz
	 2+djW1mDiNqh+BbcVm9kZP77GbinEY6x6bi2x1uyL8Jxqvo26sVaxpUXdrQmznuvrZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l7Z6r/56";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148A2606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l7Z6r/56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705B91F0089F;
	Fri,  6 Nov 2026 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793929024;
	bh=zQ2jiz+69y5r398IPcaOMAC0gMh7O1pPCwViBsbhWys=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=l7Z6r/56xV2O6ildNNYQZ1P/tWxbw3vqscX3EKfLYzHxR+gJ5rC77u0xNN7N0W/Ft
	 ksDUFlIqlX1WXKV7cReGNosKCZBdPes8gDF6j7d2WV+bvTTTo7rZa1bzIDI73iCNwc
	 JOKZTUvxEgX11Kl2VcvDmR1OqwBSp8ljgRNZlb4mjplL97FV46PxWTbgWN1ybpf9ra
	 XMH2h3Dadl/TKKvlYBTv2N0YB7BM7eDguQ6FCyJOc45UIVmGwaTHZdtwR8q/4aT0vh
	 dHXWysG3AqHURui64Dz5z4L0YT+tSFwdwYDlqHSiKEyYFG0K38u+6XYG5gJHYLeQqp
	 9CUwqnTC9b4Jg==
Message-ID: <sashiko-outbox-200524@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 37/37] scsi: mpt3sas: Update driver version to
 59.100.00.00
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-38-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-38-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:37:03 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] scsi: mpt3sas: expander link updates broken in mpt3sas_transport_u=
pdate_links()
- [High] scsi: mpt3sas: infinite retry loop on invalid handle in _scsih_add=
_device()
- [High] scsi: mpt3sas: out-of-bounds read on short events in mpt3sas_scsih=
_event_callback()
- [Medium] scsi: mpt3sas: u16 underflow of scsiio_depth in _base_allocate_m=
emory_pools()
- [Medium] scsi: mpt3sas: signed count bypasses clamp in driver trigger pag=
e helpers
- [Medium] scsi: mpt3sas: shift and u32 multiply overflow from CurrentHostP=
ageSize
--

commit 4e069d24b1cbcc20ec25652dd7863f765956c610
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Update driver version to 59.100.00.00

This series hardens bounds, size, and handle validation across the mpt3sas
driver and updates the driver version to 59.100.00.00.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 1af25a22611a1..7cc849dbf7060 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c

[ ... ]

> @@ -6434,6 +6477,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER=
 *ioc)
>  				(ioc->reply_post_queue_depth % 16);
>  	}
> =20
> +	if (facts->MaxReplyDescriptorPostQueueDepth <
> +	    MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH) {
> +		ioc_err(ioc, "MaxReplyDescriptorPostQueueDepth is too small (%u)\n",
> +			facts->MaxReplyDescriptorPostQueueDepth);
> +		return -EINVAL;
> +	}
> +
>  	if (ioc->reply_post_queue_depth >
>  	    facts->MaxReplyDescriptorPostQueueDepth) {
>  		ioc->reply_post_queue_depth =3D

[Severity: Medium]
Can this minimum check still allow an unsigned underflow of ioc->scsiio_dep=
th
further down in _base_allocate_memory_pools()?

MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH is 80, which gives ioc->hba_queue_depth =
=3D
((80 - 64) / 2) - 1 =3D 7 when ioc->reply_post_queue_depth is clamped to
facts->MaxReplyDescriptorPostQueueDepth.

Earlier in _base_allocate_memory_pools(), ioc->internal_depth is set to at
least INTERNAL_CMDS_COUNT (10) and ioc->hi_priority_depth is set to
ioc->internal_depth - 5 (at least 5):

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_allocate_memory_pools() {
	...
	if (ioc->internal_depth < INTERNAL_CMDS_COUNT) {
		...
		ioc->internal_depth =3D 10;
	}

	ioc->hi_priority_depth =3D ioc->internal_depth - (5);
	...
	ioc->scsiio_depth =3D ioc->hba_queue_depth -
	    ioc->hi_priority_depth - ioc->internal_depth;

	ioc->shost->can_queue =3D ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
}

When ioc->hba_queue_depth is less than ioc->hi_priority_depth +
ioc->internal_depth + INTERNAL_SCSIIO_CMDS_COUNT (at least 18), subtracting
ioc->hi_priority_depth and ioc->internal_depth wraps the u16 ioc->scsiio_de=
pth
around to 65528 and sets ioc->shost->can_queue to 65525.

[ ... ]

> @@ -7507,8 +7557,15 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
>  	facts->CurrentHostPageSize =3D mpi_reply.CurrentHostPageSize;
> =20
>  	/*
> -	 * Get the Page Size from IOC Facts. If it's 0, default to 4k.
> +	 * Get the Page Size from IOC Facts. If it's 0 or too large to be a
> +	 * valid shift amount, default to 4k.
>  	 */
> +	if ((facts->CurrentHostPageSize >=3D 32) ||
> +	    (facts->CurrentHostPageSize !=3D 0 && facts->CurrentHostPageSize < =
12)) {
> +		ioc_warn(ioc, "CurrentHostPageSize(%d) is invalid: Setting default hos=
t page size to 4k\n",
> +			 facts->CurrentHostPageSize);
> +		facts->CurrentHostPageSize =3D MPT3SAS_HOST_PAGE_SIZE_4K;
> +	}
>  	ioc->page_size =3D 1 << facts->CurrentHostPageSize;
>  	if (ioc->page_size =3D=3D 1) {
>  		ioc_info(ioc, "CurrentHostPageSize is 0: Setting default host page siz=
e to 4k\n");

[Severity: Medium]
When facts->CurrentHostPageSize is 31, doesn't 1 << facts->CurrentHostPageS=
ize
overflow a signed 32-bit int?

Also, if facts->CurrentHostPageSize is allowed up to 31, can the 32-bit
multiplication ioc->shost->sg_tablesize * ioc->page_size in
_ctl_do_mpt_command() wrap around?

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas=
/mpt3sas_config.c
> index b0d5ef8936008..271d7dff7c079 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c

[ ... ]

> @@ -2278,6 +2290,8 @@ mpt3sas_config_update_driver_trigger_pg2(struct MPT=
3SAS_ADAPTER *ioc,
> =20
>  	if (set) {
>  		count =3D event_tg->ValidEntries;
> +		if (count > NUM_VALID_ENTRIES)
> +			count =3D NUM_VALID_ENTRIES;
>  		tg_pg2.NumMPIEventTrigger =3D cpu_to_le16(count);
>  		for (i =3D 0; i < count; i++) {
>  			tg_pg2.MPIEventTriggers[i].MPIEventCode =3D
> @@ -2437,6 +2451,8 @@ mpt3sas_config_update_driver_trigger_pg3(struct MPT=
3SAS_ADAPTER *ioc,
> =20
>  	if (set) {
>  		count =3D scsi_tg->ValidEntries;
> +		if (count > NUM_VALID_ENTRIES)
> +			count =3D NUM_VALID_ENTRIES;
>  		tg_pg3.NumSCSISenseTrigger =3D cpu_to_le16(count);
>  		for (i =3D 0; i < count; i++) {
>  			tg_pg3.SCSISenseTriggers[i].ASCQ =3D
> @@ -2595,6 +2611,8 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT=
3SAS_ADAPTER *ioc,
> =20
>  	if (set) {
>  		count =3D mpi_tg->ValidEntries;
> +		if (count > NUM_VALID_ENTRIES)
> +			count =3D NUM_VALID_ENTRIES;
>  		tg_pg4.NumIOCStatusLogInfoTrigger =3D cpu_to_le16(count);
>  		for (i =3D 0; i < count; i++) {
>  			tg_pg4.IOCStatusLoginfoTriggers[i].IOCStatus =3D

[Severity: Medium]
In mpt3sas_config_update_driver_trigger_pg2(),
mpt3sas_config_update_driver_trigger_pg3(), and
mpt3sas_config_update_driver_trigger_pg4(), count is declared as a signed i=
nt
while ValidEntries is a uint32_t.

If userspace passes ValidEntries >=3D 0x80000000 via the diag_trigger_event,
diag_trigger_scsi, or diag_trigger_mpi sysfs attributes, won't count become
negative, bypass the count > NUM_VALID_ENTRIES check, and write the truncat=
ed
16-bit value into NumMPIEventTrigger, NumSCSISenseTrigger, or
NumIOCStatusLogInfoTrigger?

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index 8bb947004885b..1087802368c5b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c

[ ... ]

> @@ -862,6 +899,21 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, str=
uct mpt3_ioctl_command karg,
>  			ret =3D -EINVAL;
>  			goto out;
>  		}
> +		/*
> +		 * Reject an oversized transfer, since building the PRP list
> +		 * would overrun this command's fixed buffer, corrupting
> +		 * others sharing it.
> +		 */
> +		if (data_out_sz > (ioc->shost->sg_tablesize * ioc->page_size) ||
> +		    data_in_sz > (ioc->shost->sg_tablesize * ioc->page_size)) {
> +			dtmprintk(ioc, ioc_info(ioc,
> +				  "%s: data_in_size/data_out_size exceeds NVMe PRP buffer capacity\n=
",
> +				  __func__));
> +			mpt3sas_base_free_smid(ioc, smid);
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +

[Severity: Medium]
Since ioc->shost->sg_tablesize is an unsigned short and ioc->page_size is a
u32, this product is evaluated in 32-bit unsigned arithmetic. If
facts->CurrentHostPageSize is large (up to 31 in _base_get_ioc_facts()), can
ioc->shost->sg_tablesize * ioc->page_size overflow 32 bits?

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 271d7dff7c079..8bb947004885b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c

[ ... ]

> @@ -8399,6 +8426,12 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16=
 handle, u8 retry_count,
>  	u8 connector_name[5];
>  	u8 port_id;
> =20
> +	if (handle >=3D ioc->facts.MaxDevHandle) {
> +		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
> +			handle, __func__);
> +		return -1;
> +	}
> +
>  	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
>  	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
>  		ioc_err(ioc, "failure at %s:%d/%s()!\n",

[Severity: High]
Does returning -1 here cause callers to retry forever when handle >=3D
ioc->facts.MaxDevHandle?

Callers of _scsih_add_device() treat any non-zero return value as a request=
 to
retry adding a busy device:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_scan_for_devices_after_reset() {
	...
			/* This will retry adding the end device.
			 * _scsih_add_device() will decide on retries and
			 * return "1" when it should be retried
			 */
			while (_scsih_add_device(ioc, handle, retry_count++,
			    0)) {
				ssleep(1);
			}
}

and in _scsih_sas_topology_change_event():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_sas_topology_change_event() {
	...
			rc =3D _scsih_add_device(ioc, handle,
			    fw_event->retries[i], 0);
			if (rc) {/* retry due to busy device */
				fw_event->retries[i]++;
				requeue_event =3D 1;
			}
}

Because the handle >=3D ioc->facts.MaxDevHandle check in _scsih_add_device()
returns -1 on every call regardless of retry_count, wouldn't
_scsih_scan_for_devices_after_reset() loop indefinitely and
_scsih_sas_topology_change_event() requeue fw_event indefinitely instead of
dropping the invalid handle by returning 0?

[ ... ]

> @@ -12144,9 +12220,21 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAP=
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
>  		/*
>  		 * No need to add the topology change list
>  		 * event to fw event work queue when
> @@ -12158,18 +12246,45 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADA=
PTER *ioc, u8 msix_index,
>  		if (ioc->shost_recovery)
>  			return 1;
>  		break;
> +	}
>  	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> -	_scsih_check_pcie_topo_remove_events(ioc,
> +	{
> +		Mpi26EventDataPCIeTopologyChangeList_t *pcie_topo_data =3D
>  		    (Mpi26EventDataPCIeTopologyChangeList_t *)
> -		    mpi_reply->EventData);
> +		    mpi_reply->EventData;
> +		u32 data_len =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
> +		size_t hdr_size =3D
> +		    offsetof(Mpi26EventDataPCIeTopologyChangeList_t, PortEntry);
> +		u16 max_entries =3D 0;
> +
> +		if (data_len > hdr_size)
> +			max_entries =3D (data_len - hdr_size) /
> +			    sizeof(MPI26_EVENT_PCIE_TOPO_PORT_ENTRY);
> +		if (pcie_topo_data->NumEntries > max_entries)
> +			pcie_topo_data->NumEntries =3D max_entries;
> +		_scsih_check_pcie_topo_remove_events(ioc, pcie_topo_data);
>  		if (ioc->shost_recovery)
>  			return 1;
>  		break;
> +	}
>  	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
> -		_scsih_check_ir_config_unhide_events(ioc,
> +	{
> +		Mpi2EventDataIrConfigChangeList_t *ir_config_data =3D
>  		    (Mpi2EventDataIrConfigChangeList_t *)
> -		    mpi_reply->EventData);
> +		    mpi_reply->EventData;
> +		u32 data_len =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
> +		size_t hdr_size =3D
> +		    offsetof(Mpi2EventDataIrConfigChangeList_t, ConfigElement);
> +		u16 max_elements =3D 0;
> +
> +		if (data_len > hdr_size)
> +			max_elements =3D (data_len - hdr_size) /
> +			    sizeof(MPI2_EVENT_IR_CONFIG_ELEMENT);
> +		if (ir_config_data->NumElements > max_elements)
> +			ir_config_data->NumElements =3D max_elements;
> +		_scsih_check_ir_config_unhide_events(ioc, ir_config_data);
>  		break;
> +	}

[Severity: High]
What happens here if data_len < hdr_size for MPI2_EVENT_SAS_TOPOLOGY_CHANGE=
_LIST,
MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST, or MPI2_EVENT_IR_CONFIGURATION_CHANGE=
_LIST?

When data_len < hdr_size, the event is not rejected, so execution continues=
 to
alloc_fw_event_work(sz) where sz =3D le16_to_cpu(mpi_reply->EventDataLength=
) * 4:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:mpt3sas_scsih_event_callback() {
	...
	sz =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
	fw_event =3D alloc_fw_event_work(sz);
	...
	memcpy(fw_event->event_data, mpi_reply->EventData,
	    mpi_reply->EventDataLength * 4);
}

Because fw_event->event_data is allocated with only sz bytes (smaller than
hdr_size), won't the workqueue handlers _scsih_sas_topology_change_event(),
_scsih_pcie_topology_change_event(), and _scsih_sas_ir_config_change_event()
(as well as _scsih_check_topo_delete_events() and
_scsih_check_pcie_topo_remove_events() when walking queued fw_event_list
entries) read header fields such as ExpanderDevHandle, SwitchDevHandle,
NumEntries, or NumElements past the end of fw_event->event_data?

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> index e74a526efa8db..4ae11f2260143 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c

[ ... ]

> @@ -1176,6 +1178,11 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAP=
TER *ioc,
>  		return;
>  	}
> =20
> +	if (phy_number >=3D sas_node->nr_phys_allocated) {
> +		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
> +		return;
> +	}
> +
>  	mpt3sas_phy =3D &sas_node->phy[phy_number];
>  	mpt3sas_phy->attached_handle =3D handle;
>  	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);

[Severity: High]
Doesn't checking phy_number >=3D sas_node->nr_phys_allocated break link upd=
ates
for all SAS expanders?

In mpt3sas_transport_update_links(), _transport_sas_node_find_by_sas_addres=
s()
returns either &ioc->sas_hba or a SAS expander node from
ioc->sas_expander_list. While _scsih_sas_host_add() and
_scsih_sas_host_refresh() set ioc->sas_hba.nr_phys_allocated,
_scsih_expander_add() only sets sas_expander->num_phys and leaves
sas_expander->nr_phys_allocated at 0:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_expander_add() {
	...
	sas_expander =3D kzalloc_obj(struct _sas_node);
	...
	sas_expander->handle =3D handle;
	sas_expander->num_phys =3D expander_pg0.NumPhys;
	...
	sas_expander->phy =3D kzalloc_objs(struct _sas_phy,
					 sas_expander->num_phys);
}

Whenever sas_node is an expander, sas_node->nr_phys_allocated is 0, so
phy_number >=3D sas_node->nr_phys_allocated is always true and
mpt3sas_transport_update_links() returns early without updating the expander
phy link state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D37
