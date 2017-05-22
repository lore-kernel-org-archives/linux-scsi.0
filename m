From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 15/25] qla2xxx: Convert 32-bit LUN usage to 64-bit
Date: Sun, 21 May 2017 21:29:55 -0700
Message-ID: <1495427395.27407.22.camel@haakon3.risingtidesystems.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-16-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40802 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdEVE35 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 00:29:57 -0400
In-Reply-To: <20170519215344.2168-16-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Convert 32bit LUN field to 64bit LUN.
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  | 30 +++++++++++++-----------------
>  drivers/scsi/qla2xxx/qla_target.h  |  4 ++--
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  2 +-
>  3 files changed, 16 insertions(+), 20 deletions(-)
> 

Aside from the typo to hard-code LUN=0 in __qlt_24xx_handle_abts() Bart
mentioned earlier, looks fine.

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
