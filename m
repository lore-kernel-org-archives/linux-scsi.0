From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] aha152x
Date: Sat, 24 Jan 2004 15:02:12 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401241459190.1116-100000@poirot.grange>
References: <20040124120700.GA27434@linux-buechse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:32672 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S264922AbUAXOCw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jan 2004 09:02:52 -0500
In-Reply-To: <20040124120700.GA27434@linux-buechse.de>
List-Id: linux-scsi@vger.kernel.org
To: "Juergen E. Fischer" <fischer@linux-buechse.de>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>

On Sat, 24 Jan 2004, Juergen E. Fischer wrote:

> Hi,
>
> attached my patch for the aha152x driver.  Tested for pcmcia and not
> pcmcia and various devices.
>
> changes in the aha152x driver:
> - gather code that is not used by PCMCIA at the end
> - move request_region for !PCMCIA case to detection

Correct and forgive me if I am wrong, it looks like you are now poking =
at
ports without requesting them - in *_porttest. Is it a good idea?

Guennadi

> - migration to new scsi host api (remove legacy code)
> - free host scribble before scsi_done
> - fix error handling
> - one isapnp device added to id_table
>
> and in the pcmcia stub module:
> - default to synchronous transfers
> - release_region hack removed
> - let core module do the scsi host api calls.
>
>
> J=FCrgen
>

---
Guennadi Liakhovetski


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
