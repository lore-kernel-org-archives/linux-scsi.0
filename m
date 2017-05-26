From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/6] blk-mq: use the introduced blk_mq_unquiesce_queue()
Date: Fri, 26 May 2017 16:24:02 +0800
Message-ID: <20170526082326.GA29558@ming.t460p>
References: <20170526030740.26959-3-ming.lei@redhat.com>
 <201705261505.zm4lMvaq%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970752AbdEZIYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 May 2017 04:24:45 -0400
Content-Disposition: inline
In-Reply-To: <201705261505.zm4lMvaq%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Fri, May 26, 2017 at 03:46:51PM +0800, kbuild test robot wrote:
> Hi Ming,
> 
> [auto build test ERROR on block/for-next]
> [also build test ERROR on v4.12-rc2 next-20170525]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Ming-Lei/blk-mq-introduce-blk_mq_unquiesce_queue/20170526-140138
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
> config: x86_64-randconfig-x019-201721 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> Note: the linux-review/Ming-Lei/blk-mq-introduce-blk_mq_unquiesce_queue/20170526-140138 HEAD 470e70e5203ed8f76bb7c1a86db58023098bfc21 builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/scsi/scsi_lib.c: In function 'scsi_internal_device_unblock':
> >> drivers/scsi/scsi_lib.c:3033:7: error: implicit declaration of function 'blk_queue_quiesced' [-Werror=implicit-function-declaration]
>       if (blk_queue_quiesced(q))
>           ^~~~~~~~~~~~~~~~~~
>    Cyclomatic Complexity 5 include/linux/compiler.h:__read_once_size
>    Cyclomatic Complexity 5 include/linux/compiler.h:__write_once_size
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:test_and_clear_bit
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:constant_test_bit
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:variable_test_bit
>    Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:fls64
>    Cyclomatic Complexity 1 include/uapi/linux/swab.h:__swab16p
>    Cyclomatic Complexity 1 include/uapi/linux/byteorder/little_endian.h:__be16_to_cpup
>    Cyclomatic Complexity 1 include/linux/log2.h:__ilog2_u64
>    Cyclomatic Complexity 1 include/linux/list.h:INIT_LIST_HEAD
>    Cyclomatic Complexity 1 include/linux/list.h:__list_add_valid
>    Cyclomatic Complexity 1 include/linux/list.h:__list_del_entry_valid
>    Cyclomatic Complexity 2 include/linux/list.h:__list_add
>    Cyclomatic Complexity 1 include/linux/list.h:list_add_tail
>    Cyclomatic Complexity 1 include/linux/list.h:__list_del
>    Cyclomatic Complexity 2 include/linux/list.h:__list_del_entry
>    Cyclomatic Complexity 1 include/linux/list.h:list_del
>    Cyclomatic Complexity 1 include/linux/list.h:list_del_init
>    Cyclomatic Complexity 1 include/linux/list.h:list_move_tail
>    Cyclomatic Complexity 1 include/linux/list.h:list_empty
>    Cyclomatic Complexity 1 include/linux/list.h:__list_splice
>    Cyclomatic Complexity 2 include/linux/list.h:list_splice
>    Cyclomatic Complexity 2 include/linux/list.h:list_splice_init
>    Cyclomatic Complexity 1 arch/x86/include/asm/current.h:get_current
>    Cyclomatic Complexity 1 include/asm-generic/getorder.h:__get_order
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_read
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_set
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_inc
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_dec
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_add_return
>    Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_sub_return
>    Cyclomatic Complexity 1 include/linux/jump_label.h:static_key_count
>    Cyclomatic Complexity 2 include/linux/jump_label.h:static_key_false
>    Cyclomatic Complexity 1 arch/x86/include/asm/paravirt.h:arch_local_save_flags
>    Cyclomatic Complexity 1 arch/x86/include/asm/irqflags.h:arch_irqs_disabled_flags
>    Cyclomatic Complexity 5 arch/x86/include/asm/preempt.h:__preempt_count_add
>    Cyclomatic Complexity 1 arch/x86/include/asm/preempt.h:__preempt_count_dec_and_test
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spinlock_check
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spin_lock_irq
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spin_unlock_irq
>    Cyclomatic Complexity 1 include/linux/spinlock.h:spin_unlock_irqrestore
>    Cyclomatic Complexity 1 include/linux/rcupdate.h:rcu_read_lock_sched_notrace
>    Cyclomatic Complexity 1 include/linux/mm.h:lowmem_page_address
>    Cyclomatic Complexity 1 include/linux/uaccess.h:pagefault_disabled_inc
>    Cyclomatic Complexity 1 include/linux/uaccess.h:pagefault_disabled_dec
>    Cyclomatic Complexity 1 include/linux/uaccess.h:pagefault_disable
>    Cyclomatic Complexity 1 include/linux/uaccess.h:pagefault_enable
>    Cyclomatic Complexity 1 include/linux/highmem.h:kmap_atomic
>    Cyclomatic Complexity 1 include/linux/blk_types.h:op_is_write
>    Cyclomatic Complexity 1 include/linux/slab.h:kmem_cache_alloc_node
>    Cyclomatic Complexity 68 include/linux/slab.h:kmalloc_large
>    Cyclomatic Complexity 3 include/linux/slab.h:kmalloc
>    Cyclomatic Complexity 1 include/linux/slab.h:kzalloc
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_rq_is_scsi
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_rq_is_private
>    Cyclomatic Complexity 3 include/linux/blkdev.h:blk_rq_is_passthrough
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_rq_bytes
>    Cyclomatic Complexity 2 include/linux/blkdev.h:blk_rq_payload_bytes
>    Cyclomatic Complexity 2 include/linux/blkdev.h:blk_rq_nr_phys_segments
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_integrity_rq
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_rq_count_integrity_sg
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_rq_map_integrity_sg
>    Cyclomatic Complexity 1 include/linux/blkdev.h:blk_queue_max_integrity_segments
>    Cyclomatic Complexity 1 include/linux/blkdev.h:queue_max_integrity_segments
>    Cyclomatic Complexity 3 include/linux/dma-mapping.h:dma_get_max_seg_size
>    Cyclomatic Complexity 2 include/linux/dma-mapping.h:dma_set_seg_boundary
>    Cyclomatic Complexity 1 include/linux/dma-mapping.h:dma_max_pfn
>    Cyclomatic Complexity 1 include/linux/blk-mq.h:blk_mq_rq_to_pdu
>    Cyclomatic Complexity 1 include/linux/unaligned/access_ok.h:get_unaligned_be16
>    Cyclomatic Complexity 1 include/scsi/scsi_common.h:scsi_varlen_cdb_length
>    Cyclomatic Complexity 2 include/scsi/scsi_common.h:scsi_command_size
>    Cyclomatic Complexity 2 include/scsi/scsi_common.h:scsi_sense_valid
>    Cyclomatic Complexity 3 include/scsi/scsi.h:scsi_status_is_good
>    Cyclomatic Complexity 1 include/scsi/scsi_device.h:scsi_target
>    Cyclomatic Complexity 1 include/scsi/scsi_device.h:scsi_device_online
>    Cyclomatic Complexity 1 include/scsi/scsi_device.h:scsi_device_blocked
>    Cyclomatic Complexity 1 include/scsi/scsi_request.h:scsi_req
>    Cyclomatic Complexity 1 include/scsi/scsi_cmnd.h:scsi_cmd_to_driver
>    Cyclomatic Complexity 1 include/scsi/scsi_cmnd.h:scsi_set_resid
>    Cyclomatic Complexity 1 include/scsi/scsi_cmnd.h:scsi_get_resid
>    Cyclomatic Complexity 3 include/scsi/scsi_cmnd.h:scsi_bidi_cmnd
>    Cyclomatic Complexity 2 include/scsi/scsi_cmnd.h:scsi_in
>    Cyclomatic Complexity 2 include/scsi/scsi_cmnd.h:scsi_prot_sg_count
>    Cyclomatic Complexity 1 include/scsi/scsi_cmnd.h:set_host_byte
>    Cyclomatic Complexity 3 include/scsi/scsi_eh.h:scsi_sense_is_deferred
>    Cyclomatic Complexity 3 include/scsi/scsi_host.h:scsi_host_in_recovery
>    Cyclomatic Complexity 1 include/scsi/scsi_host.h:scsi_get_device
>    Cyclomatic Complexity 1 include/scsi/scsi_host.h:scsi_host_get_prot
>    Cyclomatic Complexity 1 include/scsi/scsi_host.h:scsi_host_prot_dma
>    Cyclomatic Complexity 1 drivers/scsi/scsi_priv.h:scsi_log_send
>    Cyclomatic Complexity 1 drivers/scsi/scsi_priv.h:scsi_log_completion
>    Cyclomatic Complexity 2 drivers/scsi/scsi_lib.c:scsi_select_sense_cache
>    Cyclomatic Complexity 1 drivers/scsi/scsi_lib.c:scsi_alloc_sense_buffer
>    Cyclomatic Complexity 4 drivers/scsi/scsi_lib.c:scsi_set_blocked
>    Cyclomatic Complexity 3 drivers/scsi/scsi_lib.c:scsi_device_is_busy
>    Cyclomatic Complexity 4 drivers/scsi/scsi_lib.c:scsi_target_is_busy
>    Cyclomatic Complexity 5 drivers/scsi/scsi_lib.c:scsi_host_is_busy
>    Cyclomatic Complexity 3 drivers/scsi/scsi_lib.c:scsi_uninit_cmd
> 
> vim +/blk_queue_quiesced +3033 drivers/scsi/scsi_lib.c
> 
>   3027				sdev->sdev_state = SDEV_CREATED;
>   3028		} else if (sdev->sdev_state != SDEV_CANCEL &&
>   3029			 sdev->sdev_state != SDEV_OFFLINE)
>   3030			return -EINVAL;
>   3031	
>   3032		if (q->mq_ops) {
> > 3033			if (blk_queue_quiesced(q))
>   3034				blk_mq_unquiesce_queue(q);
>   3035			else
>   3036				blk_mq_start_stopped_hw_queues(q, false);

My fault, I shouldn't have merged blk_queue_quiesced()
into patch 03, will fix it in V2.

Thanks,
Ming
