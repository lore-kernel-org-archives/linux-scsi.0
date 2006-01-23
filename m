From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 02:09:13 -0500
Message-ID: <20060123070913.GA20822@havoc.gtf.org>
References: <11379893762140-git-send-email-htejun@gmail.com> <11379893764141-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11379893764141-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2006 at 01:09:36PM +0900, Tejun Heo wrote:
> Export two SCSI EH command handling functions.  To be used by libata EH.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> ---
> 
> James, this patch is a part of libata-EH related updates.  After the
> update, libata EH uses functions exported from this patch to retry or
> complete failed commands.

ACK (obviously).  We'll want to un-export scsi_finish_command() once
this is all done.

	Jeff



