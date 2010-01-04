From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH] SCSI/ibmvscsi: fix a typo in a source code comment
Date: Mon, 4 Jan 2010 17:19:09 +0100
Message-ID: <e2e108261001040819w218b13c1ja7939c6fd3014e1d@mail.gmail.com>
References: <200912042043.37328.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:39990 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0ADQTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 11:19:12 -0500
Received: by ey-out-2122.google.com with SMTP id 22so161614eye.19
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2010 08:19:10 -0800 (PST)
In-Reply-To: <200912042043.37328.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>

On Fri, Dec 4, 2009 at 8:43 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index e475b79..e3a18e0 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -40,7 +40,7 @@
> =A0* (CRQ), which is just a buffer of 16 byte entries in the receiver=
's
> =A0* Senders cannot access the buffer directly, but send messages by
> =A0* making a hypervisor call and passing in the 16 bytes. =A0The hyp=
ervisor
> - * puts the message in the next 16 byte space in round-robbin fashio=
n,
> + * puts the message in the next 16 byte space in round-robin fashion=
,
> =A0* turns on the high order bit of the message (the valid bit), and
> =A0* generates an interrupt to the receiver (if interrupts are turned=
 on.)
> =A0* The receiver just turns off the valid bit when they have copied =
out

Hello James,

Does anyone have to ack this trivial patch before it can be added to
the scsi-misc-2.6.git repository ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
