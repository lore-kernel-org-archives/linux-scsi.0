From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [2.6 patch] scsi/lpfc/: possible cleanups
Date: Wed, 14 Nov 2007 08:42:53 -0500
Message-ID: <473AFB5D.5030303@emulex.com>
References: <20071105170733.GQ12045@stusta.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52826 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbXKNNnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 08:43:14 -0500
In-Reply-To: <20071105170733.GQ12045@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

ACK

-- james s

Adrian Bunk wrote:
> This patch contains the following possible cleanups:
> - make the following needlessly global functions static:
>   - lpfc_els.c: lpfc_register_new_vport()
>   - lpfc_els.c: lpfc_issue_els_fdisc()
>   - lpfc_els.c: lpfc_issue_fabric_iocb()
>   - lpfc_els.c: lpfc_fabric_abort_vport()
>   - lpfc_hbadisc.c: lpfc_dev_loss_tmo_handler()
>   - lpfc_hbadisc.c: lpfc_mbx_cmpl_clear_la()
>   - lpfc_hbadisc.c: lpfc_disc_flush_list()
>   - lpfc_hbadisc.c: __lpfc_find_node()
>   - lpfc_init.c: lpfc_hb_timeout()
>   - lpfc_init.c: lpfc_block_mgmt_io()
>   - lpfc_sli.c: __lpfc_sli_release_iocbq()
>   - lpfc_sli.c: lpfc_sli_next_hbq_slot()
>   - lpfc_sli.c: lpfc_sli_hbqbuf_init_hbqs()
>   - lpfc_sli.c: lpfc_sli_hbqbuf_find()
>   - lpfc_sli.c: __lpfc_sli_issue_iocb()
> - #if 0 the following unused global functions:
>   - lpfc_els.c: lpfc_fabric_abort_flogi()
>   - lpfc_hbadisc.c: lpfc_find_node()
>   - lpfc_hbadisc.c: lpfc_findnode_rpi()
> - remove the unused exports
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/scsi/lpfc/lpfc_crtn.h    |   19 -------------------
>  drivers/scsi/lpfc/lpfc_els.c     |   18 ++++++++++++++----
>  drivers/scsi/lpfc/lpfc_hbadisc.c |   13 +++++++++----
>  drivers/scsi/lpfc/lpfc_init.c    |   22 +++++++++++-----------
>  drivers/scsi/lpfc/lpfc_sli.c     |   10 +++++-----
>  drivers/scsi/lpfc/lpfc_vport.c   |    3 ---
>  6 files changed, 39 insertions(+), 46 deletions(-)
> 
