From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [FEATURE REQUEST] megaraid2 driver
Date: Thu, 22 Apr 2004 09:59:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC577@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58539 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264057AbUDVN7X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 09:59:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Lester Hightower' <hightowe@10east.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> On Thu, 22 Apr 2004, Mukker, Atul wrote:
> 
> > > we inserted a fresh disk it automatically marked as a hot 
> spare.  That
> > > went well, however, it took almost two hours to rebuild 73G
> > > on u320 disks
> > > in raid-1, which surprised me since the Mylex Acceleraid 170
> > > (u160) took
> > > less than an hour in the same test.  I'm not complaining
> > > about the speed,
> >
> > What was the rebuild rate
> 
> 30%
You can play around with this value to decrease the rebuild timing. This has
a direct affect on the IO throughput though
