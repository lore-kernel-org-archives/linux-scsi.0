From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCHv7 00/26] scsi logging update (the boring part)
Date: Tue, 07 Oct 2014 15:52:52 -0400
Message-ID: <1412711572.5241.180.camel@localhost.localdomain>
References: <1412672605-42868-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaJGTxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 15:53:24 -0400
In-Reply-To: <1412672605-42868-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, 2014-10-07 at 11:02 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> here is not the seventh iteration of my scsi-logging update.
> The changes to v6 are:
> - fixup scsi_print_result() to not issue a '(null)' string
>   (noticed by Ewan Milne)
> - Use matching command names in sd_print_result
> - Minor coding issue in scsi_opcode_sa_name()
>   (noticed by Doug Gilbert)
> 
> Hannes Reinecke (26):
>   Remove scsi_cmd_print_sense_hdr()
>   sd: Remove scsi_print_sense() in sd_done()
>   aha152x: Debug output update and whitespace cleanup
>   scsi: introduce sdev_prefix_printk()
>   scsi: Use sdev as argument for sense code printing
>   acornscsi: use scsi_print_command()
>   fas216: Return DID_ERROR for incomplete data transfer
>   fas216: Update logging messages
>   53c700: remove scsi_print_sense() usage
>   scsi: stop decoding if scsi_normalize_sense() fails
>   scsi: do not decode sense extras
>   scsi: use 'bool' as return value for scsi_normalize_sense()
>   scsi: remove scsi_print_status()
>   Implement scsi_opcode_sa_name
>   scsi: merge print_opcode_name()
>   scsi: consolidate opcode lookup in scsi_opcode_sa_name()
>   scsi: repurpose the last argument from print_opcode_name()
>   scsi: Remove scsi_print_command when calling abort
>   scsi: separate out scsi_(host|driver)byte_string()
>   sd: Cleanup logging
>   scsi: simplify scsi_log_(send|completion)
>   scsi: fixup logging messages in scsi_error.c
>   scsi: use shost argument in scsi_eh_prt_fail_stats
>   scsi_error: document scsi_try_to_abort_cmd
>   scsi: check for correct return code in scsi_eh_abort_cmds()
>   scsi: correct return values for .eh_abort_handler implementations
> 
>  drivers/scsi/53c700.c             |  13 +-
>  drivers/scsi/NCR5380.c            |   7 +-
>  drivers/scsi/aha152x.c            | 994 +++++++++-----------------------------
>  drivers/scsi/aha1740.c            |   2 +-
>  drivers/scsi/arm/acornscsi.c      |  12 +-
>  drivers/scsi/arm/fas216.c         |  39 +-
>  drivers/scsi/atari_NCR5380.c      |   3 +-
>  drivers/scsi/ch.c                 |  29 +-
>  drivers/scsi/constants.c          | 578 +++++++++-------------
>  drivers/scsi/esas2r/esas2r_main.c |   2 +-
>  drivers/scsi/hosts.c              |   4 +-
>  drivers/scsi/megaraid.c           |   8 +-
>  drivers/scsi/osst.c               |   8 +-
>  drivers/scsi/ps3rom.c             |   4 -
>  drivers/scsi/scsi.c               |  45 +-
>  drivers/scsi/scsi_error.c         | 123 ++---
>  drivers/scsi/scsi_ioctl.c         |   2 +-
>  drivers/scsi/scsi_lib.c           |  19 +-
>  drivers/scsi/sd.c                 |  60 +--
>  drivers/scsi/sd.h                 |   6 +-
>  drivers/scsi/sg.c                 |   6 +-
>  drivers/scsi/sr.h                 |   3 +-
>  drivers/scsi/sr_ioctl.c           |  10 +-
>  drivers/scsi/st.c                 |   9 +-
>  drivers/scsi/stex.c               |   9 +-
>  drivers/scsi/storvsc_drv.c        |   3 +-
>  drivers/scsi/sun3_NCR5380.c       |   3 +-
>  include/scsi/scsi_dbg.h           |  28 +-
>  include/scsi/scsi_device.h        |   9 +
>  include/scsi/scsi_eh.h            |  14 +-
>  30 files changed, 690 insertions(+), 1362 deletions(-)
> 

All patches in series Reviewed-by: Ewan D. Milne <emilne@redhat.com>


