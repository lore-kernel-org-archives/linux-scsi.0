From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 12:58:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F94EE@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:17133 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264239AbUFPQ7b
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 12:59:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> +		case EH_RESET_TIMER:
> +			/* This allows a single retry even of a command
> +			 * with allowed == 0 */
> +			if (scmd->retries++ > scmd->allowed)
> +				break;
> +			scsi_add_timer(scmd, scmd->timeout_per_command,
> +				       scsi_times_out);
> +			return;

So why increment the retries counter at all ? 
