From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] SCSI/ibmvscsi: fix a typo in a source code comment
Date: Mon, 04 Jan 2010 12:57:57 -0600
Message-ID: <4B423A35.7080908@linux.vnet.ibm.com>
References: <200912042043.37328.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46908 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0ADS5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jan 2010 13:57:52 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o04IrkpA032692
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 13:53:46 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o04IvpHx116022
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 13:57:51 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o04Ivoiv005363
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2010 16:57:50 -0200
In-Reply-To: <200912042043.37328.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 12/04/2009 01:43 PM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index e475b79..e3a18e0 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -40,7 +40,7 @@
>   * (CRQ), which is just a buffer of 16 byte entries in the receiver's 
>   * Senders cannot access the buffer directly, but send messages by
>   * making a hypervisor call and passing in the 16 bytes.  The hypervisor
> - * puts the message in the next 16 byte space in round-robbin fashion,
> + * puts the message in the next 16 byte space in round-robin fashion,
>   * turns on the high order bit of the message (the valid bit), and 
>   * generates an interrupt to the receiver (if interrupts are turned on.) 
>   * The receiver just turns off the valid bit when they have copied out
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
