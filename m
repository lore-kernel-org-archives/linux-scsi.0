From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [gregoire.favre@gmail.com: What breaks aic7xxx in post
	2.6.12-rc2 ?]
Date: Mon, 16 May 2005 16:07:24 -0500
Message-ID: <1116277644.5040.45.camel@mulgrave>
References: <20050516152607.GA27989@infradead.org>
	 <1116258401.5040.14.camel@mulgrave> <20050516155409.GE9558@gmail.com>
	 <1116261212.5040.23.camel@mulgrave>  <20050516180531.GA9144@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44722 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261879AbVEPVHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 17:07:34 -0400
In-Reply-To: <20050516180531.GA9144@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-16 at 20:05 +0200, Gr=E9goire Favre wrote:
> Unfortunately, it don't seems to change anything, 2.6.12-rc4-mm1 is i=
n a
> infinite loop :

Actually, the loop's not infinite; it's dropping the transfer parameter=
s
each time it goes around ... it should exit after 8 or so.

> aic7xxx_abort returns 0x2002
> scsi1:0:1:0: Attempting to queue an ABORT message
> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> scsi1:0:1:0: Command found on device queue
> aic7xxx_abort returns 0x2002
> scsi: Device offlined - not ready after error recovery: host 1 channe=
l 0
>  target1:0:1: domain Validation detected failure, dropping back
> scsi1:0:1:0: Attempting to queue an ABORT message

I'm fairly certain it's something to do with the DVD settings.  Could
you send me the output of

/proc/scsi/aic7xxx/1

With the earlier version of the kernel

Thanks,

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
