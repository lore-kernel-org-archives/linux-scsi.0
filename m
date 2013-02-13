From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [scsi:misc 61/65] drivers/scsi/fnic/fnic_scsi.c:441:3: warning:
 cast from pointer to integer of different size
Date: Wed, 13 Feb 2013 01:09:43 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B12892AFB5@xmb-rcd-x08.cisco.com>
References: <5108bd1a.8xz9RnqCpU8wRGNk%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:44647 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3BMBJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 20:09:45 -0500
In-Reply-To: <5108bd1a.8xz9RnqCpU8wRGNk%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <35DD95963676434A946093666050AA46@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James,

I have fixed fnic patches 3-10 for sparse and smatch errors.

Thanks,
Hiral

On 1/29/13 10:26 PM, "kbuild test robot" <fengguang.wu@intel.com> wrote:

>tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
>head:   52cb5cbe9b8ed89db0f8c9eeec8410fcfb0887fd
>commit: 6f3b5679f2af1ef3becbf7832d2bce977907c08a [61/65] [SCSI] fnic:
>fixing issues in device and firmware reset code
>config: make ARCH=i386 allmodconfig
>
>All warnings:
>
>   drivers/scsi/fnic/fnic_scsi.c:190:39: sparse: context imbalance in
>'__fnic_set_state_flags' - unexpected unlock
>   drivers/scsi/fnic/fnic_scsi.c:419:19: sparse: context imbalance in
>'fnic_queuecommand_lck' - unexpected unlock
>   drivers/scsi/fnic/fnic_scsi.c:2411:49: sparse: context imbalance in
>'fnic_is_abts_pending' - different lock contexts for basic block
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_queuecommand_lck':
>>> drivers/scsi/fnic/fnic_scsi.c:441:3: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:441:3: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:493:3: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:493:3: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:515:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:515:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:515:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_fcpio_ack_handler':
>>> drivers/scsi/fnic/fnic_scsi.c:703:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function
>'fnic_fcpio_icmnd_cmpl_handler':
>>> drivers/scsi/fnic/fnic_scsi.c:747:3: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:747:3: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:904:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:904:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:904:2: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function
>'fnic_fcpio_itmf_cmpl_handler':
>>> drivers/scsi/fnic/fnic_scsi.c:1022:5: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:1022:5: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:1022:5: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:1044:4: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:1044:4: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:1044:4: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_scsi.c:1059:4: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>--
>   drivers/scsi/fnic/fnic_trace.c: In function 'fnic_trace_get_buf':
>>> drivers/scsi/fnic/fnic_trace.c:80:9: warning: cast to pointer from
>>>integer of different size [-Wint-to-pointer-cast]
>   drivers/scsi/fnic/fnic_trace.c: In function 'fnic_get_trace_data':
>>> drivers/scsi/fnic/fnic_trace.c:112:10: warning: cast to pointer from
>>>integer of different size [-Wint-to-pointer-cast]
>>> drivers/scsi/fnic/fnic_trace.c:149:10: warning: cast to pointer from
>>>integer of different size [-Wint-to-pointer-cast]
>   drivers/scsi/fnic/fnic_trace.c: In function 'fnic_trace_buf_init':
>>> drivers/scsi/fnic/fnic_trace.c:200:21: warning: cast from pointer to
>>>integer of different size [-Wpointer-to-int-cast]
>>> drivers/scsi/fnic/fnic_trace.c:207:2: warning: cast to pointer from
>>>integer of different size [-Wint-to-pointer-cast]
>>> drivers/scsi/fnic/fnic_trace.c:215:10: warning: cast to pointer from
>>>integer of different size [-Wint-to-pointer-cast]
>   drivers/scsi/fnic/fnic_trace.c: In function 'fnic_trace_free':
>>> drivers/scsi/fnic/fnic_trace.c:260:9: warning: cast to pointer from
>>>integer of different size [-Wint-to-pointer-cast]
>
>sparse warnings: (new ones prefixed by >>)
>
>>> drivers/scsi/fnic/fnic_scsi.c:190:39: sparse: context imbalance in
>>>'__fnic_set_state_flags' - unexpected unlock
>   drivers/scsi/fnic/fnic_scsi.c:419:19: sparse: context imbalance in
>'fnic_queuecommand_lck' - unexpected unlock
>>> drivers/scsi/fnic/fnic_scsi.c:2411:49: sparse: context imbalance in
>>>'fnic_is_abts_pending' - different lock contexts for basic block
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_queuecommand_lck':
>   drivers/scsi/fnic/fnic_scsi.c:441:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:441:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:493:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:493:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:515:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:515:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:515:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_fcpio_ack_handler':
>   drivers/scsi/fnic/fnic_scsi.c:703:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function
>'fnic_fcpio_icmnd_cmpl_handler':
>   drivers/scsi/fnic/fnic_scsi.c:747:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:747:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:904:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:904:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:904:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function
>'fnic_fcpio_itmf_cmpl_handler':
>   drivers/scsi/fnic/fnic_scsi.c:1022:5: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1022:5: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1022:5: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1044:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1044:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1044:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1059:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1059:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1059:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_cleanup_io':
>   drivers/scsi/fnic/fnic_scsi.c:1213:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1213:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function
>'fnic_wq_copy_cleanup_handler':
>   drivers/scsi/fnic/fnic_scsi.c:1276:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1276:3: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_abort_cmd':
>   drivers/scsi/fnic/fnic_scsi.c:1709:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:1709:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c: In function 'fnic_device_reset':
>   drivers/scsi/fnic/fnic_scsi.c:2190:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   drivers/scsi/fnic/fnic_scsi.c:2190:2: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>
>vim +441 drivers/scsi/fnic/fnic_scsi.c
>
>   413			return SCSI_MLQUEUE_HOST_BUSY;
>   414	
>   415		atomic_inc(&fnic->in_flight);
>   416	
>   417		/*
>   418		 * Release host lock, use driver resource specific locks from
>here.
>   419		 * Don't re-enable interrupts in case they were disabled prior to
>the
>   420		 * caller disabling them.
>   421		 */
>   422		spin_unlock(lp->host->host_lock);
>   423		CMD_FLAGS(sc) = FNIC_CDB_REQ;
>   424	
>   425		/* Get a new io_req for this SCSI IO */
>   426		io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
>   427		if (!io_req) {
>   428			ret = SCSI_MLQUEUE_HOST_BUSY;
>   429			goto out;
>   430		}
>   431		memset(io_req, 0, sizeof(*io_req));
>   432	
>   433		/* Map the data buffer */
>   434		sg_count = scsi_dma_map(sc);
>   435		if (sg_count < 0) {
>   436			mempool_free(io_req, fnic->io_req_pool);
>   437			goto out;
>   438		}
>   439	
>   440		/* Determine the type of scatter/gather list we need */
> > 441		io_req->sgl_cnt = sg_count;
>   442		io_req->sgl_type = FNIC_SGL_CACHE_DFLT;
>   443		if (sg_count > FNIC_DFLT_SG_DESC_CNT)
>   444			io_req->sgl_type = FNIC_SGL_CACHE_MAX;
>   445	
>   446		if (sg_count) {
>   447			io_req->sgl_list =
>   448				mempool_alloc(fnic->io_sgl_pool[io_req->sgl_type],
>   449					      GFP_ATOMIC);
>   450			if (!io_req->sgl_list) {
>   451				ret = SCSI_MLQUEUE_HOST_BUSY;
>   452				scsi_dma_unmap(sc);
>   453				mempool_free(io_req, fnic->io_req_pool);
>   454				goto out;
>   455			}
>   456	
>   457			/* Cache sgl list allocated address before alignment */
>   458			io_req->sgl_list_alloc = io_req->sgl_list;
>   459			ptr = (unsigned long) io_req->sgl_list;
>   460			if (ptr % FNIC_SG_DESC_ALIGN) {
>   461				io_req->sgl_list = (struct host_sg_desc *)
>   462					(((unsigned long) ptr
>   463					  + FNIC_SG_DESC_ALIGN - 1)
>   464					 & ~(FNIC_SG_DESC_ALIGN - 1));
>   465			}
>   466		}
>   467	
>   468		/* initialize rest of io_req */
>   469		io_req->port_id = rport->port_id;
>   470		CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
>   471		CMD_SP(sc) = (char *)io_req;
>   472		sc->scsi_done = done;
>   473	
>   474		/* create copy wq desc and enqueue it */
>   475		wq = &fnic->wq_copy[0];
>   476		ret = fnic_queue_wq_copy_desc(fnic, wq, io_req, sc, sg_count);
>   477		if (ret) {
>   478			/*
>   479			 * In case another thread cancelled the request,
>   480			 * refetch the pointer under the lock.
>   481			 */
>   482			spinlock_t *io_lock = fnic_io_lock_hash(fnic, sc);
>   483	
>   484			spin_lock_irqsave(io_lock, flags);
>   485			io_req = (struct fnic_io_req *)CMD_SP(sc);
>   486			CMD_SP(sc) = NULL;
>   487			CMD_STATE(sc) = FNIC_IOREQ_CMD_COMPLETE;
>   488			spin_unlock_irqrestore(io_lock, flags);
>   489			if (io_req) {
>   490				fnic_release_ioreq_buf(fnic, io_req, sc);
>   491				mempool_free(io_req, fnic->io_req_pool);
>   492			}
>   493		}
>   494	out:
>   495		atomic_dec(&fnic->in_flight);
>   496		/* acquire host lock before returning to SCSI */
>   497		spin_lock(lp->host->host_lock);
>   498		return ret;
>   499	}
>   500	
>   501	DEF_SCSI_QCMD(fnic_queuecommand)
>   502	
>   503	/*
>   504	 * fnic_fcpio_fw_reset_cmpl_handler
>   505	 * Routine to handle fw reset completion
>   506	 */
>   507	static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
>   508						    struct fcpio_fw_req *desc)
>   509	{
>   510		u8 type;
>   511		u8 hdr_status;
>   512		struct fcpio_tag tag;
>   513		int ret = 0;
>   514		unsigned long flags;
>   515	
>   516		fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
>   517	
>   518		/* Clean up all outstanding io requests */
>
>---
>0-DAY kernel build testing backend              Open Source Technology
>Center
>http://lists.01.org/mailman/listinfo/kbuild                 Intel
>Corporation

