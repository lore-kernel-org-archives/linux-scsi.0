From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/3] scsi-trace: remove service action definitions
Date: Thu, 24 Mar 2016 09:03:24 -0400
Message-ID: <1458824604.17965.69.camel@localhost.localdomain>
References: <1458815011-9054-1-git-send-email-hare@suse.de>
	 <1458815011-9054-2-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbcCXND1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2016 09:03:27 -0400
In-Reply-To: <1458815011-9054-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, 2016-03-24 at 11:23 +0100, Hannes Reinecke wrote:
> scsi_opcode_name() is displaying the opcode, not the service
> action.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  include/trace/events/scsi.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index 079bd10..5c0d91f 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -95,10 +95,6 @@
>  		scsi_opcode_name(VERIFY_16),			\
>  		scsi_opcode_name(WRITE_SAME_16),		\
>  		scsi_opcode_name(SERVICE_ACTION_IN_16),		\
> -		scsi_opcode_name(SAI_READ_CAPACITY_16),		\
> -		scsi_opcode_name(SAI_GET_LBA_STATUS),		\
> -		scsi_opcode_name(MI_REPORT_TARGET_PGS),		\
> -		scsi_opcode_name(MO_SET_TARGET_PGS),		\
>  		scsi_opcode_name(READ_32),			\
>  		scsi_opcode_name(WRITE_32),			\
>  		scsi_opcode_name(WRITE_SAME_32),		\

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


