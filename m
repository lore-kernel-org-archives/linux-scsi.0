From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Aic94xx and Linux kernel 2.6.19
Date: Sun, 12 Nov 2006 14:23:05 -0500
Message-ID: <45577499.1010101@garzik.org>
References: <834553.41356.qm@web31804.mail.mud.yahoo.com> <4557707B.8040701@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54997 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1752863AbWKLTXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Nov 2006 14:23:14 -0500
In-Reply-To: <4557707B.8040701@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: ltuikov@yahoo.com, mike.redan@bell.ca, James.Bottomley@SteelEye.com, alexisb@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>

Darrick J. Wong wrote:
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 7af2a4b..5c1fc46 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1612,9 +1612,9 @@ early_finish:
> 
>  err_did:
>  	ata_qc_free(qc);
> -err_mem:
>  	cmd->result = (DID_ERROR << 16);
>  	done(cmd);
> +err_mem:
>  	DPRINTK("EXIT - internal\n");
>  	return 0;


Yep, that looks like a bug (and correct fix)

I'll queue it, but let me know results from your testing regardless.

	Jeff


