Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899383;
	b=hIdEjmAeGDvwVzdZYsmXfVy8vICS/97VsY8mx1dehDvRZZmK6xDixTg3Jz3RN7LCoi3F
	 Oxqbhs4ZiH0PTA8tpW5mYvYN0T9b3V9YxeFM5vau3k1XY142FqSA43UvPw4N4IemQOLcf
	 8uIz4r5XT5a6fUeHJWDjGcpOzxO59XfJNu2WDIy+nmMt+IV/q6pNFjPaVSL2zPIOqpwtY
	 k8S16RFXkOtG9tlS8vDjcbyb7fs/KjTbUkuctxEX5HrqSJqLXZ1TQu08Y+lzM89ASIohx
	 x7ZQQkd8PJB5Cpq0R/MLbFs6C/BZLSkzLcqGQSKwB7puxk9N1G1VWGjYBbmPcTpv9QQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899383;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=El2gDPaHKNQS/iVbeg/u9DEG2g2OxMLt+hVb8WDvQQ8=;
	b=QCRZ3nHJeTdVKKn8cLGw+y1K+T8A9DZ7waXeBFEL3IRF1+PU0Nak9Dg5Ubjo1Vs4CB+7
	 B9MK1JrB1YbnX9ZhO+T+fL6phqjFNVwmJudBn97azC8mr5lon/k+D+noVOl16dqdMpQvq
	 4G2BPbUxaAoxkEkOcuWxyo+FpZEpMLyAGkPzZQqBYdvwLC/tu3gr4G38RpX6D3Jl+Dh81
	 CLdvSf9TDWc33cCSEytb52oa4noMF5A0u46Ac7syRr1DWsUYBPQ5T8qWg/m3r2lpWRpJM
	 kB2zWDUEbY0uWSAAOHfowospMYPexsicokVer6UZZHzXX0jI14ZUa54JQ5rGtgCA2Bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZmQQRvv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA297606EEB0;
	Thu,  5 Nov 2026 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZmQQRvv
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899382;
	b=nLdP501K5E7fo5udqiajO4KWdlBp6nfzCkJXl1nviq4aWOCv4NoQhIjq+KNysPD1ipSi
	 qXfsynJPuObsrI4Es4vqvvbxUfyqm9eZrUAARbt+YGblGjX9SzzQ59pmYWemLro6Erwwt
	 pprx4ZWXShVQP1hFhiVINCuHG0WalcM0uCQic1/nswFU1eMJsXKZ7pR5jmCuGRVw2iU/x
	 VJKe0yiZ2lUTOyb+HyKTo89nG5AsQASvz0aLwNdnIbju+CA6WRFs7SxpoSitpHq2IPEta
	 cgK6SShbQNnWEDAGMlIlLOfyjmOsvs1lwzCWUKwN47TPhhauXH4XZa5lkfL+H7K6HtA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899382;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=El2gDPaHKNQS/iVbeg/u9DEG2g2OxMLt+hVb8WDvQQ8=;
	b=je1KygADX8LZZjzh7fotSIy0/Hc/BymrbwmMgdLQYmjTH2aa6iJskf/6vEOCkdSOumXI
	 S3LfU7eMId+BGe4PtjvH++AUepMnVE+SGRc4yF9728NItJsnuTObaTxpLZgJrwuyqle6Y
	 9BAWpXJE9UzQRQ3lyKi/jdGDLc0N0cD23nNUCaXB0HlSNb6wzNTEKOJC1ehYULl0P9Jzh
	 TQV+pdqlQyaWBNEDLQIdx5GyE4rI9E54VLvUlsxFH419Gj5MnUj6CVQPluNk1A7LYvckQ
	 sEyLu2xxItkO0V17Pu6scTSN24VhmtaxMOtCDnYA7D9n3jK2EIIsYw8guN2PiF4h+WQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C314C1F000C1;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899382;
	bh=El2gDPaHKNQS/iVbeg/u9DEG2g2OxMLt+hVb8WDvQQ8=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=nZmQQRvv0RojMxCbcwbTnlKYepfJMRxfYlJ3XvpmRGkQO7ltQ9+6ahXxO8v+6/pxa
	 oqq4LJbV+PRaamF2p1G8SKsITWR8O0js54lEE+D0zjubD+zsu9ABnZhOXle3mzjJGJ
	 Jd50OFdmEFcZ5xP9dEEf1SG7N6l17N9MeaiRunRQ62CS9xVtgcqMy9tEAmQN49C+vR
	 VrEVxaoT8hY5FYljJTYAn//6jtPFBVYmvjDtz0MRvc9tvWQ4S00WINGQmXLk1vRZcb
	 C7+fcn5yNA74mPrwxmisATZTIgTK7fq001IT4eegzXz46iaw2EOIeoPPoEQ8ynYbuz
	 Fk/L/TOFB3FwA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 25FB64736E;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH v18 00/13] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 05 Nov 2026 11:22:53 -0600
Message-Id: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XRzWrDMAwH8FcpOc9B/nZ62nuMHWxHXj3aJDhpa
 Cl999nd2LKSHCWkn/6gWzViijhW+92tSjjHMfZdLqh52VX+YLsPJLHNjYoBU9AwSaI7zcGTMMS
 OjOdh6NNEEJ0VLRgnmKzy5pAwxMuDfXv/rsez+0Q/FapMhNSfyHRIaP/pIEQDUAsquABCyXRNe
 Gxfj7E7X+p8ufb9qawf4jj16fqIPVNW7vwYHFYT5iECRHLLQwi61do9oSXmTPmvRAH0hsSz5Ax
 V1gUrgverklhIVG5IIksWHCjuTGuYXJXkUmo2JFkkI41mCqk2dlVSC4mpDUkVKT/BWiU1tuuZ9
 J+UqQ1JZ6lBlIE20vqGPkv3+/0Lq7OtDIACAAA=
X-Change-ID: 20260925-ibmvfc-fpin-support-eeba4d08b425
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=18381;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=G1upE+9TQa5mwbat6N9rERFR+uKci8yttX0EZdNqi7g=;
 b=VtOndU/IuDBLQvDdPtm7Ki9fZRprCERDPGqkTCIJSXIdoN6PNuvxNVCyy1sRSDTpou/s8hunq
 Oz22FLcMzK4BXCCFfgmjlrtLBs94FPl/rMcM3xbLVveMIX+vrIMbHyb
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

This patch series adds FPIN (fabric performance impact notification)
support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
in three flavors:

- basic, to recognize existing FPIN messages from the virtual I/O
  server (VIOS) (patch 6)
- full, supporting additional FPIN information and using its own
  asynchronous sub-queue and interrupt (patches 8-12)
- extended, supporting FC-LS-5 (patch 13)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 7).

The asynchronous sub-queue work is split across five patches: patch 8
defines the necessary data structures, patch 9 extends the async event
handlers to accept events from the new queue, patch 10 adds the
interrupt and drain routines for the queue, patch 11 extends channel
registration to accommodate the new queue, and patch 12 registers the
queue during channel initialization, advertises support to VIOS during
NPIV login, and routes events from the queue to the handlers. Patches
1-5 fix IRQ cleanup and error handling bugs exposed during that work.
Patch 13 adds extended FPIN handling on top of the new queue.

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_fpin_rcv for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>

---
Changes in v18:
- Removed stray diffs in commit message for patch 12.
- Link to v17: https://lore.kernel.org/r/20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com

Changes in v17:
- new patch 4 (fix stale rc and IRQ mapping leak in
  ibmvfc_register_channel()): set rc = -EINVAL in the default: case of
  the protocol switch to prevent a stale h_reg_sub_crq() return value
  (0 or H_CLOSED) being returned to the caller after the sub-CRQ is
  freed; introduce irq_mapping_failed: label to dispose the IRQ mapping
  and clear scrq->irq before falling through to irq_failed, fixing a
  leak when irq_create_mapping() succeeds but a later step fails
- patch 5 (fix resource leaks on partial queue allocation failure):
  add ibmvfc_free_event_pool() calls on the get_zeroed_page() and
  dma_mapping_error() failure paths in ibmvfc_alloc_queue() to fix
  an event pool leak when ibmvfc_init_event_pool() succeeds but a
  later step fails; rename patch subject to reflect broader scope
- patch 6 (add basic FPIN support): allocate fpin_workq after
  ibmvfc_alloc_mem() in ibmvfc_probe() to prevent double-free of
  resources that ibmvfc_alloc_mem() already unwound on failure; deliver
  LINK_CONGESTED and CONGESTION_CLEARED events whose identifiers are all
  zero as host-scope FPIN events, and silently drop other statuses with
  no identifiers; set detecting_wwpn in the FPIN descriptors from
  fc_host_port_name() instead of leaving it zero; add KUnit cases for the
  host-scope and dropped zero-identifier events
- patch 9 (extend async event handlers for async sub-CRQ events): add
  assoc_id parameter to ibmvfc_find_target() and match on tgt->assoc_id
  when nonzero; when an async sub-CRQ event has IBMVFC_ASYNC_ID_IS_ASSOC_ID
  set, extract assoc_id from subq->id.assoc_id and pass it to the target
  lookup so NVMe targets sharing a wwpn are distinguished by association ID;
  propagate assoc_id into the ELS LOGO/PRLO/PLOGI target loops in
  ibmvfc_handle_async() for the same reason; when no target is found for
  a LINK_CONGESTED or CONGESTION_CLEARED event, fall back to a
  host-scope descriptor as for basic FPIN; set detecting_wwpn in the
  full FPIN descriptors; use a severity of 0 for PORT_CLEARED and
  CONGESTION_CLEARED events
- patch 10 (add interrupt routine for asynchronous sub CRQ): collect
  async sub-CRQ events into a deferred list while holding host_lock and
  q_lock and dispatch them after releasing both, re-taking host_lock
  around each ibmvfc_handle_async() call, avoiding a potential lockdep
  recursive locking warning from ibmvfc_handle_async() calling
  ibmvfc_purge_requests() which acquires q_lock instances of the same
  lockdep class
- patch 11 (extend channel registration for async sub-CRQ): rename the
  patch and correct its commit message, which said
  ibmvfc_deregister_channel() was changed when only
  ibmvfc_register_channel() is
- patch 12 (register and use asynchronous sub CRQ): move
  mq_enabled/do_enquiry flag clearing out of ibmvfc_reg_sub_crqs() and
  into each caller; in ibmvfc_reenable_crq_queue() and
  ibmvfc_reset_crq(), deregister all channel sets and clear mq_enabled
  and do_enquiry if any ibmvfc_reg_sub_crqs() call fails, preventing
  leaked hypervisor sub-CRQ registrations; set async_sub_crq_handle
  unconditionally in ibmvfc_channel_setup() so the handle is sent to
  VIOS even on the CANCEL_CHANNELS path
- patch 13 (handle extended FPIN events): pass detecting_wwpn through
  ibmvfc_ext_fpin_to_desc(); correct the @severity kernel-doc to say
  severity is only carried by the congestion descriptor
  (LINK_CONGESTED and CONGESTION_CLEARED); drop the redundant
  IBMVFC_FPIN_EVENT_TYPE_VALID test in ibmvfc_ext_fpin_to_desc(); remove
  volatile from the valid field of struct ibmvfc_async_subq_fpin; move
  the static_assert() checks to file scope
- Link to v16: https://lore.kernel.org/r/20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com

Changes in v16:
- new patch 4: fix unguarded dma_unmap_single() in ibmvfc_free_queue();
  guard dma_unmap_single() and free_page() together under the msgs.handle
  check to prevent calling dma_unmap_single() with address 0 on a
  partially initialized queue
- patch 5 (add basic FPIN support): restore per-adapter fpin_workq instead
  of schedule_work(); destroy it after ibmvfc_release_crq_queue() in
  ibmvfc_remove() to ensure in-flight work items drain before tgt_pool is
  freed and to close the original race where queue_work() could be called
  on a destroyed workqueue pointer; fix probe error unwind to call
  destroy_workqueue() before ibmvfc_free_mem()
- patch 10 (extend channel reg/dereg helpers): initialize scrq->hwq_id
  before request_irq() so error logging in ibmvfc_toggle_scrq_irq() shows
  the correct index if an early interrupt triggers before hwq_id was set
- patch 11 (register and use asynchronous sub CRQ): clamp
  scsi->active_queues and nvme->active_queues to max_queues in
  ibmvfc_channel_setup_done() to prevent out-of-bounds scrqs[] access on
  a malformed hypervisor response; take host_lock around bitfield writes
  to mq_enabled, do_enquiry, and nvme_enabled in ibmvfc_reg_sub_crqs()
  and ibmvfc_init_sub_crqs() to prevent lost updates from concurrent
  read-modify-write on the packed bitfield word; remove mq_enabled guard
  from ibmvfc_dereg_sub_crqs() to prevent previously registered channel
  sets being skipped on teardown after a registration failure; change
  ibmvfc_reg_sub_crqs() to return int and check its return value in
  ibmvfc_init_sub_crqs() so each channel set failure triggers correct
  per-set cleanup
- Link to v15: https://patch.msgid.link/20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com

Changes in v15:
- patch 4 (add basic FPIN support): restore per-adapter fpin_workq instead
  of schedule_work(); destroy it after ibmvfc_release_crq_queue() in
  ibmvfc_remove() to ensure in-flight work items drain before tgt_pool is
  freed and to close the original race where queue_work() could be called
  on a destroyed workqueue pointer
- patch 9 (extend channel reg/dereg helpers): initialize scrq->hwq_id
  before request_irq() so error logging in ibmvfc_toggle_scrq_irq() shows
  the correct index if an early interrupt triggers before hwq_id was set
- patch 10 (register and use asynchronous sub CRQ): clamp scsi->active_queues
  and nvme->active_queues to max_queues in ibmvfc_channel_setup_done() to
  prevent out-of-bounds scrqs[] access on a malformed hypervisor response;
  take host_lock around bitfield writes to mq_enabled, do_enquiry, and
  nvme_enabled in ibmvfc_reg_sub_crqs() and ibmvfc_init_sub_crqs() to
  prevent lost updates from concurrent read-modify-write on the packed
  bitfield word
- Link to v14: https://patch.msgid.link/20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com

Changes in v14:
- Fix double-free of sub-CRQ at the hypervisor level: guard
  H_FREE_SUB_CRQ in ibmvfc_deregister_channel() on scrq->cookie != 0
  and clear cookie to zero on success; also clear cookie in the
  ibmvfc_register_channel() irq_failed: rollback path (patch 3)
- Add SCSI_IBMVFC_KUNIT_TEST Kconfig entry, Makefile line, and
  ibmvfc_kunit.c with ibmvfc_deregister_channel_guard_test() verifying
  the cookie and msgs.handle guard paths (patch 3)
- Fix wild pointer dereference in ibmvfc_handle_scrq(): change signature
  to accept struct ibmvfc_queue *scrq and use &scrq->evt_pool for event
  validation instead of &evt->queue->evt_pool (patch 5)
- Fix NULL pointer dereference in ibmvfc_channel_setup_done() when
  mq_enabled=0: compute async->active_queues from the VIOS response
  guarded by async->scrqs != NULL; guard async->scrqs[0].cookie access
  in ibmvfc_channel_setup() with a NULL check (patch 10)
- Fix host state machine stall on ibmvfc_reg_sub_crqs() failure: clear
  vhost->mq_enabled in addition to do_enquiry so ibmvfc_npiv_login_done()
  takes the non-channel fallback path and wakes the work queue (patch 10)
- Link to v13: https://patch.msgid.link/20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com

Changes in v13:
- Updated to 7.4/scsi-staging base
- Extend ibmvfc_common_fpin_to_desc() with a severity parameter;
  ibmvfc_ext_fpin_to_desc() now honours IBMVFC_FPIN_SEVERITY_VALID
  and propagates the severity from the VIOS rather than always
  defaulting to FPIN_CONGN_SEVERITY_WARNING (patch 11)
- Handle scsi_host_get() failure in ibmvfc_get_first_vhost() (patch 4)
- Add kernel-doc comment to ibmvfc_get_first_vhost() (patch 4)
- Use list_for_each_entry to find an online FCP/NVMe target rport in
  KUnit tests rather than taking the first list entry unconditionally
  (patches 4, 7, 11)
- Link to v12: https://patch.msgid.link/20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com

Changes in v12:
- Wrap ibmvfc_handle_async() invocations in KUnit tests with host_lock to
  prevent races with workqueue destruction on concurrent device removal
  (patches 4, 7, 11)
- Add missing scsi_host_put() in success exit path of ibmvfc_async_fpin_test()
  (patch 4)
- Pass resolved tgt->wwpn into ibmvfc_full_fpin_to_desc() instead of subq->wwpn
  so FPIN descriptors are correctly populated when subq->wwpn is 0 (patch 7)
- Fix kernel-doc comments in ibmvfc_register_channel() and
  ibmvfc_deregister_channel() that incorrectly directed passing a negative index
  (patch 9)
- Fix double registration of scsi_scrqs in ibmvfc_reenable_crq_queue() by
  registering async_scrqs instead (patch 10)
- Link to v11: https://lore.kernel.org/linux-scsi/20260925044900.414340-1-tyreld@linux.ibm.com/

Changes in v11:
- Split the IRQ cleanup and NULL-pointer fixes out of the "register and
  use" patch into two dedicated bug-fix patches (patches 1-2 and 1-3),
  making the series 11 patches instead of 9
- Replaced the single ibmvfc_queue async_sub_crq field in ibmvfc_host with
  an ibmvfc_channels async_scrqs field, reusing the existing channel
  infrastructure for allocation, registration, and teardown (patches 6, 9, 10)
- Added IBMVFC_PROTO_ASYNC to enum ibmvfc_protocol; ibmvfc_register_channel()
  and ibmvfc_deregister_channel() now dispatch on protocol rather than a
  negative-index sentinel (patch 9)
- Added IBMVFC_ASYNC_SUB_CRQ_FMT format enum value and corresponding
  async_scrq pointer in union ibmvfc_msgs (patch 6)
- ibmvfc_alloc_channels() selects IBMVFC_ASYNC_SUB_CRQ_FMT for async
  protocol channels so queues are sized for ibmvfc_async_sub_crq entries
  (patch 10)
- Link to v10: https://lore.kernel.org/linux-scsi/20260911021910.1038128-1-tyreld@linux.ibm.com/

Changes in v10:
- Fix ibmvfc_find_target() to use logical and (&&) instead of logical or (||)
  when checking whether fc and nvme remote ports are NULL (patch 4)
- Fix build issues due to missing & operator when referencing the host lock
  during irqsave/restore calls (patch 4, patch 7, patch 8, patch 11)
- Fix kunit build issues caused by inclusion of code meant for later patches
  (patch 4, patch 7, patch 11)
- Link to v9: https://lore.kernel.org/linux-scsi/20260911021910.1038128-1-tyreld@linux.ibm.com/

Changes in v9:
- Fix ibmvfc_find_target() to check for either a valid rport or nvme_remote_port
  so nvme targets are not silently dropped (patch 4)
- Restore xxx_host_remove() ordering and destroy async work queue prior to these
  calls. Check that the host is not offline prior to enqueuing new async work
  (patch 4)
- Link to v8: https://lore.kernel.org/linux-scsi/20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com

Changes in v8:
- Split patch 6 into two patches: extend channel registration/deregistration
  for async subq (patch 9), and clear sub-CRQ IRQ on registration failure
  and guard teardown (patch 1)
- Fixed NULL dereference in ibmvfc_deregister_channel() when called on
  an unallocated queue: guard memset() behind scrq->msgs.handle check
- Fixed variable-shadowing bug in ibmvfc_register_channel() error path
  where H_FREE_SUB_CRQ hcall result clobbered the return code
- Deregister and re-register async sub-CRQ in ibmvfc_reenable_crq_queue()
  and ibmvfc_reset_crq() alongside SCSI channel queues
- Link to v7: https://patch.msgid.link/20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com

Changes in v7:
- Removed CRQ valid bit clearing to callers of ibmvfc_handle_async in
  all cases
- Added validity checks that IBMVFC_ASYNC_ID_IS_ASSOC_ID is clear
  before using node_name
- Fixed error path cleanup in ibmvfc_init_sub_crqs
- Deregister and reregister async sub-CRQ in CRQ reset and reenable
  code.
- Moved work queue destruction after sub CRQs teardown in ibmvfc_remove
- Modified async event handling code to use a tagged union rather than
  void *.
- Use WQ_UNBOUND rather than WQ_PERCPU for fpin workqueue, as FPIN
  events should be rare. Hold q_lock only in
  ibmvfc_drain_async_subq(), like ibmvfc_drain_sub_crq().
- Hardened KUnit tests to use host_lock and kref.
- Link to v6: https://patch.msgid.link/20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com

Changes in v6:
- Use alloc_workqueue rather than devm_alloc_workqueue, and add
  explicit destroy_workqueue calls
- Moved ibmvfc_find_target into patch 4
- Link to v5: https://patch.msgid.link/20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com

Changes in v5:
- Incorporate changes for NVME-over-FC.
- Removed now redundant fabric login patch.
- Link to v4: https://patch.msgid.link/20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com

Changes in v4:
- Refactored channel registration
- Check whether async work queue is allocated before using or freeing
- Fixed work queue allocation/destruction
- Skip basic KUnit test when there are no ibmvfc devices available
- Fix target not found condition in ibmvfc_process_async_work
- Link to v3: https://patch.msgid.link/20260702-ibmvfc-fpin-support-v3-0-d95b9747cf88@linux.ibm.com

Changes in v3:
- Fixed latent bug, exposed by VFC_NOOP, related to dataless CRQs and events
- Fixed FPIN TLV descriptor length calculations
- Use safe list walker to walk targets in ibmvfc_process_async_work
- Added write memory barriers after clearing CRQ valid field
- Use per-vhost work queue for FPIN work
- Link to v2: https://patch.msgid.link/20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com

Highlights of changes in v2:
- Refactored mostly common FPIN conversion routines and async event
  processing into single routines with wrappers for differences.
- Moved FPIN processing to a work queue to avoid conflicts with
  fc_host_fpin_rcv and memory allocation
- Set descriptor sizes correctly
- Use target WWPN for basic FPIN descriptor
- Split patch 4 into 3 patches, for definition, allocation, and use of
  the asynchronous sub-queue for events
- Link to v1: https://patch.msgid.link/20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com

---
Dave Marquardt (11):
      scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
      scsi: ibmvfc: fix stale rc and IRQ mapping leak in ibmvfc_register_channel()
      scsi: ibmvfc: fix resource leaks on partial queue allocation failure
      scsi: ibmvfc: add basic FPIN support
      scsi: ibmvfc: add NOOP command support
      scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
      scsi: ibmvfc: extend async event handlers for async sub-CRQ events
      scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
      scsi: ibmvfc: extend channel registration for async sub-CRQ
      scsi: ibmvfc: register and use asynchronous sub CRQ for events
      scsi: ibmvfc: handle extended FPIN events

Tyrel Datwyler (2):
      scsi: ibmvfc: fix potential clobbering of rc after failed irq setup
      scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation

 drivers/scsi/Kconfig                 |   10 +
 drivers/scsi/ibmvscsi/Makefile       |    1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 1009 ++++++++++++++++++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h       |   69 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c |  584 ++++++++++++++++++++
 5 files changed, 1575 insertions(+), 98 deletions(-)
---
base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
change-id: 20260925-ibmvfc-fpin-support-eeba4d08b425

Best regards,
-- 
Dave Marquardt <davemarq@linux.ibm.com>


