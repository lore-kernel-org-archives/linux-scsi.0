From: "R. J. Wysocki" <rjwysocki@sisk.pl>
Subject: Re: 2.6.6-mm5
Date: Sat, 22 May 2004 13:51:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405221351.37361.rjwysocki@sisk.pl>
References: <20040522013636.61efef73.akpm@osdl.org> <40AF18E7.4040509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from grendel.digitalservice.pl ([217.67.200.140]:726 "HELO
	mail.digitalservice.pl") by vger.kernel.org with SMTP
	id S264946AbUEVLnb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 07:43:31 -0400
Received: from mail.digitalservice.pl ([127.0.0.1])
 by localhost (grendel [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 26691-03 for <linux-scsi@vger.kernel.org>;
 Sat, 22 May 2004 13:51:21 +0200 (CEST)
In-Reply-To: <40AF18E7.4040509@pobox.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Saturday 22 of May 2004 11:09, Jeff Garzik wrote:
> Andrew Morton wrote:
> > - Added a new SATA RAID driver from 3ware.  From a quick peek it seem to
> >   need a little work yet.
>
> It's not too bad... but it looks more like a 2.2 driver forward ported
> to 2.4, than a 2.6.x driver.  Needs some luvin' from the 2.6 scsi api crew.
>
> Overall, it appears to be a message-based firmware engine like
> drivers/block/carmel.c, that hides the SATA details in the firmware.

BTW, which 3ware driver would you suggest to use with the 2.6.x now?  I'm 
going to install such a controller in my box ...

RJW

