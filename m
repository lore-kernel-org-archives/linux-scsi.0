From: "Smitha Narayanaswamy \(smithan\)" <smithan@cisco.com>
Subject: RE: [linux-iscsi-devel] [PATCH]cleanup of xmit_task
Date: Fri, 26 Nov 2004 16:19:43 +0530
Message-ID: <000001c4d3a5$a3e7f990$6f074d0a@apac.cisco.com>
References: <41A4C00E.5080603@netapp.com>
Reply-To: <smithan@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:15128 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262373AbUKZTWA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 14:22:00 -0500
In-Reply-To: <41A4C00E.5080603@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'David Wysochanski' <davidw@netapp.com>
Cc: linux-iscsi-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

<..snip>

> @@ -720,17 +720,6 @@ fill_task_immediate_data(struct iscsi_ta
>   	struct crypto_tfm *tfm= NULL;
>   	struct scatterlist tmpsg;
>
> -	/* make sure we have data to send when we expect to */
> -	if ((iscsi_expected_data_length(sc) == 0) &&
> -	    ((sc->request_bufflen == 0) || (sc->request_buffer
> == NULL))) {
> -		printk("iSCSI: xmit_task for itt %u, sc 0x%x,
> expected %u, no "
> -		       "data in buffer. request_buffer %p len
> %u, buffer %p "
> -		       "len %u\n", task->itt, sc->cmnd[0],
> -		       iscsi_expected_data_length(sc),
> sc->request_buffer,
> -		       sc->request_bufflen, sc->buffer, sc->bufflen);
> -		scsi_print_command(sc);
> -		return 0;
> -	}
>
> What protects this function from being called with a scsi command
> that has no data?  Are you sure we don't need this check with maybe
> just a return here?
>

Is it possible to have scsi write command with no data being sent?

<snip..>

Thanks,
Smitha


