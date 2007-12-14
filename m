From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 18/30] scsi/qla2xxx/: possible cleanups
Date: Fri, 14 Dec 2007 07:37:24 -0800
Message-ID: <20071214153723.GC1823@plap3.qlogic.org>
References: <200712140014.lBE0ELSg026228@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27896 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXLNPh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2007 10:37:27 -0500
Content-Disposition: inline
In-Reply-To: <200712140014.lBE0ELSg026228@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@kernel.org

On Thu, 13 Dec 2007, akpm@linux-foundation.org wrote:

> From: Adrian Bunk <bunk@kernel.org>
> 
> - make the following needlessly global code static:
>   - qla_attr.c: qla24xx_vport_delete()
>   - qla_attr.c: qla24xx_vport_disable()
>   - qla_mid.c: qla24xx_allocate_vp_id()
>   - qla_mid.c: qla24xx_find_vhost_by_name()
>   - qla_mid.c: qla2x00_do_dpc_vp()
>   - qla_os.c: struct qla2x00_driver_template
>   - qla_os.c: qla2x00_stop_timer()
>   - qla_os.c: qla2x00_mem_alloc()
>   - qla_os.c: qla2x00_mem_free()
>   - qla_sup.c: qla2x00_lock_nvram_access()
>   - qla_sup.c: qla2x00_unlock_nvram_access()
>   - qla_sup.c: qla2x00_get_nvram_word()
>   - qla_sup.c: qla2x00_write_nvram_word()
> - #if 0 the following unused global functions:
>   - qla_dbg.c: qla2x00_dump_pkt()
>   - qla_mbx.c: qla2x00_system_error()
>   - qla_mbx.c: qla2x00_get_serdes_params()
>   - qla_mbx.c: qla2x00_get_idma_speed()
>   - qla_mbx.c: qla24xx_get_vp_database()
>   - qla_mbx.c: qla24xx_get_vp_entry()
> - qla_os.c: remove some unneeded function prototypes
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew,

Could you drop this patch from your queue.  I'll carry it in my tree
(along with additional code removals) for 2.6.25 submission.

Thanks,
Andrew Vasquez
