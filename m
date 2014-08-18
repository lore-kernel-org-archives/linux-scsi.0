From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fix various kernel-doc problems in scsi_error.c
Date: Mon, 18 Aug 2014 11:44:37 -0400
Message-ID: <1408376677.1223.208.camel@localhost.localdomain>
References: <53EFC9DF.1030707@infradead.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaHRPpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2014 11:45:06 -0400
In-Reply-To: <53EFC9DF.1030707@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2014-08-16 at 14:15 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Convert spaces to tabs in kernel-doc notation.
> Correct duplicated (copy-paste) kernel-doc comments that are incorrect.
> Fix kernel-doc warning:
> 
> Warning(..//drivers/scsi/scsi_error.c:1647): No description found for parameter 'shost'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Cleaning this stuff up is great, see the notes below...

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

> ---
>  drivers/scsi/scsi_error.c |   23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> Index: lnx-317-rc1/drivers/scsi/scsi_error.c
> ===================================================================
> --- lnx-317-rc1.orig/drivers/scsi/scsi_error.c
> +++ lnx-317-rc1/drivers/scsi/scsi_error.c
> @@ -1238,8 +1238,8 @@ retry_tur:
>  /**
>   * scsi_eh_test_devices - check if devices are responding from error recovery.
>   * @cmd_list:	scsi commands in error recovery.
> - * @work_q:     queue for commands which still need more error recovery
> - * @done_q:     queue for commands which are finished
> + * @work_q:	queue for commands which still need more error recovery
> + * @done_q:	queue for commands which are finished
>   * @try_stu:    boolean on if a STU command should be tried in addition to TUR.

There are still tabs instead of spaces after @try_stu.

>   *
>   * Decription:
> @@ -1373,7 +1373,7 @@ static int scsi_eh_try_stu(struct scsi_c
>   /**
>   * scsi_eh_stu - send START_UNIT if needed
>   * @shost:	&scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>   * @done_q:	&list_head for processed commands.
>   *
>   * Notes:
> @@ -1436,7 +1436,7 @@ static int scsi_eh_stu(struct Scsi_Host
>  /**
>   * scsi_eh_bus_device_reset - send bdr if needed
>   * @shost:	scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>   * @done_q:	&list_head for processed commands.
>   *
>   * Notes:
> @@ -1502,7 +1502,7 @@ static int scsi_eh_bus_device_reset(stru
>  /**
>   * scsi_eh_target_reset - send target reset if needed
>   * @shost:	scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>   * @done_q:	&list_head for processed commands.
>   *
>   * Notes:
> @@ -1567,7 +1567,7 @@ static int scsi_eh_target_reset(struct S
>  /**
>   * scsi_eh_bus_reset - send a bus reset
>   * @shost:	&scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>   * @done_q:	&list_head for processed commands.
>   */
>  static int scsi_eh_bus_reset(struct Scsi_Host *shost,
> @@ -1638,8 +1638,9 @@ static int scsi_eh_bus_reset(struct Scsi
>  
>  /**
>   * scsi_eh_host_reset - send a host reset
> - * @work_q:	list_head for processed commands.
> - * @done_q:	list_head for processed commands.
> + * @shost: 	host to be reset.

There is a space before the tab after @shost.

> + * @work_q:	&list_head for pending commands.
> + * @done_q:	&list_head for processed commands.
>   */
>  static int scsi_eh_host_reset(struct Scsi_Host *shost,
>  			      struct list_head *work_q,
> @@ -1677,8 +1678,8 @@ static int scsi_eh_host_reset(struct Scs
>  
>  /**
>   * scsi_eh_offline_sdevs - offline scsi devices that fail to recover
> - * @work_q:	list_head for processed commands.
> - * @done_q:	list_head for processed commands.
> + * @work_q:	&list_head for pending commands.
> + * @done_q:	&list_head for processed commands.
>   */
>  static void scsi_eh_offline_sdevs(struct list_head *work_q,
>  				  struct list_head *done_q)
> @@ -2044,7 +2045,7 @@ static void scsi_restart_operations(stru
>  /**
>   * scsi_eh_ready_devs - check device ready state and recover if not.
>   * @shost: 	host to be recovered.

There a space before the tab after @shost.

> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>   * @done_q:	&list_head for processed commands.
>   */
>  void scsi_eh_ready_devs(struct Scsi_Host *shost,
> --


