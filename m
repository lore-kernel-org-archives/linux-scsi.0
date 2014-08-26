From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fix various kernel-doc problems in scsi_error.c
Date: Tue, 26 Aug 2014 10:48:19 +0200
Message-ID: <53FC49D3.40900@suse.de>
References: <53EFC9DF.1030707@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362AbaHZIsV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 04:48:21 -0400
In-Reply-To: <53EFC9DF.1030707@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 08/16/2014 11:15 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Convert spaces to tabs in kernel-doc notation.
> Correct duplicated (copy-paste) kernel-doc comments that are incorrec=
t.
> Fix kernel-doc warning:
>
> Warning(..//drivers/scsi/scsi_error.c:1647): No description found for=
 parameter 'shost'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>   drivers/scsi/scsi_error.c |   23 ++++++++++++-----------
>   1 file changed, 12 insertions(+), 11 deletions(-)
>
> Index: lnx-317-rc1/drivers/scsi/scsi_error.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- lnx-317-rc1.orig/drivers/scsi/scsi_error.c
> +++ lnx-317-rc1/drivers/scsi/scsi_error.c
> @@ -1238,8 +1238,8 @@ retry_tur:
>   /**
>    * scsi_eh_test_devices - check if devices are responding from erro=
r recovery.
>    * @cmd_list:	scsi commands in error recovery.
> - * @work_q:     queue for commands which still need more error recov=
ery
> - * @done_q:     queue for commands which are finished
> + * @work_q:	queue for commands which still need more error recovery
> + * @done_q:	queue for commands which are finished
>    * @try_stu:    boolean on if a STU command should be tried in addi=
tion to TUR.
>    *
>    * Decription:
> @@ -1373,7 +1373,7 @@ static int scsi_eh_try_stu(struct scsi_c
>    /**
>    * scsi_eh_stu - send START_UNIT if needed
>    * @shost:	&scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>    * @done_q:	&list_head for processed commands.
>    *
>    * Notes:
> @@ -1436,7 +1436,7 @@ static int scsi_eh_stu(struct Scsi_Host
>   /**
>    * scsi_eh_bus_device_reset - send bdr if needed
>    * @shost:	scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>    * @done_q:	&list_head for processed commands.
>    *
>    * Notes:
> @@ -1502,7 +1502,7 @@ static int scsi_eh_bus_device_reset(stru
>   /**
>    * scsi_eh_target_reset - send target reset if needed
>    * @shost:	scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>    * @done_q:	&list_head for processed commands.
>    *
>    * Notes:
> @@ -1567,7 +1567,7 @@ static int scsi_eh_target_reset(struct S
>   /**
>    * scsi_eh_bus_reset - send a bus reset
>    * @shost:	&scsi host being recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>    * @done_q:	&list_head for processed commands.
>    */
>   static int scsi_eh_bus_reset(struct Scsi_Host *shost,
> @@ -1638,8 +1638,9 @@ static int scsi_eh_bus_reset(struct Scsi
>
>   /**
>    * scsi_eh_host_reset - send a host reset
> - * @work_q:	list_head for processed commands.
> - * @done_q:	list_head for processed commands.
> + * @shost: 	host to be reset.
> + * @work_q:	&list_head for pending commands.
> + * @done_q:	&list_head for processed commands.
>    */
>   static int scsi_eh_host_reset(struct Scsi_Host *shost,
>   			      struct list_head *work_q,
> @@ -1677,8 +1678,8 @@ static int scsi_eh_host_reset(struct Scs
>
>   /**
>    * scsi_eh_offline_sdevs - offline scsi devices that fail to recove=
r
> - * @work_q:	list_head for processed commands.
> - * @done_q:	list_head for processed commands.
> + * @work_q:	&list_head for pending commands.
> + * @done_q:	&list_head for processed commands.
>    */
>   static void scsi_eh_offline_sdevs(struct list_head *work_q,
>   				  struct list_head *done_q)
> @@ -2044,7 +2045,7 @@ static void scsi_restart_operations(stru
>   /**
>    * scsi_eh_ready_devs - check device ready state and recover if not=
=2E
>    * @shost: 	host to be recovered.
> - * @work_q:     &list_head for pending commands.
> + * @work_q:	&list_head for pending commands.
>    * @done_q:	&list_head for processed commands.
>    */
>   void scsi_eh_ready_devs(struct Scsi_Host *shost,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
