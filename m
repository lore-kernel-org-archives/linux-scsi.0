From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
 (end devices)
Date: Tue, 13 Sep 2005 23:37:36 +0200
Message-ID: <432746A0.50402@s5r6.in-berlin.de>
References: <1126308304.4799.45.camel@mulgrave> <20050910024454.20602.qmail@web51613.mail.yahoo.com> <20050911094656.GC5429@infradead.org> <43251D8C.7020409@torque.net> <1126537041.4825.28.camel@mulgrave> <20050912164548.GB11455@us.ibm.com> <1126545680.4825.40.camel@mulgrave> <20050912184629.GA13489@us.ibm.com> <1126639342.4809.53.camel@mulgrave> <4327354E.7090409@adaptec.com> <20050913203611.GH32395@parisc-linux.org> <43273E6C.9050807@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49596 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750898AbVIMVj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 17:39:56 -0400
In-Reply-To: <43273E6C.9050807@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, Christoph Hellwig <hch@infradead.org>, Luben Tuikov <ltuikov@yahoo.com>

Luben Tuikov wrote:
> I've never seen the symbols "lun".

It is merely an encoding of a variable name or struct member name 
according to the coding style spec.

> "task->ssp_task.LUN"

But SSP is a TLA too, isn't it? ;-)
-- 
Stefan Richter
-=====-=-=-= =--= -==-=
http://arcgraph.de/sr/
