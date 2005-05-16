From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: [gregoire.favre@gmail.com: What breaks aic7xxx in post 2.6.12-rc2 ?]
Date: Mon, 16 May 2005 20:05:31 +0200
Message-ID: <20050516180531.GA9144@gmail.com>
References: <20050516152607.GA27989@infradead.org> <1116258401.5040.14.camel@mulgrave> <20050516155409.GE9558@gmail.com> <1116261212.5040.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.198]:48739 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261712AbVEPSFf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 14:05:35 -0400
Received: by rproxy.gmail.com with SMTP id a41so745442rng
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 11:05:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116261212.5040.23.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, May 16, 2005 at 11:33:32AM -0500, James Bottomley wrote:

> The initial fix was just to disbelieve the device if it didn't suppor=
t
> ppr.  Could you try the attached?  It expands the check to disbelieve
> the return for all CD type devices.

Unfortunately, it don't seems to change anything, 2.6.12-rc4-mm1 is in =
a
infinite loop :

aic7xxx_abort returns 0x2002
scsi1:0:1:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1:0:1:0: Command found on device queue
aic7xxx_abort returns 0x2002
scsi: Device offlined - not ready after error recovery: host 1 channel =
0
 target1:0:1: domain Validation detected failure, dropping back
scsi1:0:1:0: Attempting to queue an ABORT message
=2E..

Thank for the explanation and the patch :-)
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
