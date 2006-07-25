From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: fibre channel sync cache question
Date: Tue, 25 Jul 2006 16:51:12 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70248EE0@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10993 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030209AbWGYWv1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 18:51:27 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: dougg@torque.net, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Michael Reed <mdr@sgi.com>

-- Tuesday, July 25, 2006 4:40 PM, Arjan van de Ven 

> 
> Hi,
> 
> that sounds sooo like the wrong approach... wouldn't it be 
> better to fix
> sg instead?
> 
> 

Agreed.  We want to remove our sync cache code when its fully handled
from all cases above.
