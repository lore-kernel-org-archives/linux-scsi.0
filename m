From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SCSI IO Errors
Date: Sun, 07 Sep 2003 18:47:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062956848.16964.26.camel@dhcp23.swansea.linux.org.uk>
References: <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
	 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
	 <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:40939 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S263376AbTIGRsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Sep 2003 13:48:41 -0400
In-Reply-To: <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Jaenichen <mj2@percomp.de>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, linux-scsi@vger.kernel.org

On Sad, 2003-09-06 at 19:59, Matthias Jaenichen wrote:
> (scsi0:A:0): 20.000MB/s transfers (10.000MHz, offset 31, 16bit)
>    Vendor: SEAGATE   Model: ST318436LW        Rev: 0010
>    Type:   Direct-Access                      ANSI SCSI revision: 03

>From the traces the disk is stopping responding, it then fails to
react to an abort and your trace ends at the reset issue so its hard to
see what happened then.

Does seatools show up anyting on the disk ?

Adaptec themselves have a forum for this stuff which is maintained by 
Justin Gibbs, the aic7xxx author

