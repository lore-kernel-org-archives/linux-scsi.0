From: Jens Laas <jens.laas@data.slu.se>
Subject: Re: 2.6.14-rc2-git7 crashed on amd64 (usenet gateway) after 18 hours
Date: Fri, 30 Sep 2005 15:04:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0509301457460.5429@localhost>
References: <dhinf5$skf$1@news.cistron.nl> <20050930001301.08eeab9d.akpm@osdl.org>
 <dhj7qr$id0$1@news.cistron.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.slu.se ([130.238.96.11]:34259 "EHLO mail1.slu.se")
	by vger.kernel.org with ESMTP id S1030291AbVI3NEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 09:04:44 -0400
In-Reply-To: <dhj7qr$id0$1@news.cistron.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Danny ter Haar <dth@cistron.nl>
Cc: linux-scsi@vger.kernel.org

(05.09.30 kl.11:33) Danny ter Haar skrev f=F6ljande till linux-scsi@vge=
r.kern...:

> Andrew Morton  <akpm@osdl.org> wrote:

> My colleque found in kern.log the real first announcement:
>
> Sep 30 00:26:54 newsgate kernel: scsi1: Transmission error detected
> Sep 30 00:26:54 newsgate kernel: LQISTAT1[0x8]:(LQICRCI_NLQ) LASTPHAS=
E[0x1]:(P_DATAOUT|P_BUSFREE)
> Sep 30 00:26:54 newsgate kernel: SCSISIGI[0x60]:(P_DATAIN_DT) PERRDIA=
G[0x4]:(CRCERR)
> Sep 30 00:26:54 newsgate kernel: >>>>>>>>>>>>>>>>>> Dump Card State B=
egins <<<<<<<<<<<<<<<<<

I dont know if its the same problem as above but we have seen this:
Sep  1 14:21:00 mail1 kernel: scsi1: Unexpected PKT busfree condition
Sep  1 14:21:00 mail1 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins=
=20
<<<<<<<<<<<<<<<<<

busfree is mentioned in both.

What is most disappointing is that there is no recovery. Which is no fu=
n=20
when 2700 mail accounts becomes unreachable.

I would expect the card to be reinitialized and communication resumed.

=46ailing that I would like the error be communicated upwards in the ke=
rnel=20
so some sort of recovery on fs level can be done (forced unmount perhap=
s).

Cheers,
Jens

> etc...
>
> Hope this gives more info on the crash..
>
> Danny
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-----------------------------------------------------------------------
     'This mail automatically becomes portable when carried.'
-----------------------------------------------------------------------
     Jens L=E5=E5s                              Email: jens.laas@data.s=
lu.se
     Department of Computer Services, SLU   Phone: +46 18 67 35 15
     Vindbrov=E4gen 1
     P.O. Box 7079
     S-750 07 Uppsala
     SWEDEN
-----------------------------------------------------------------------
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
