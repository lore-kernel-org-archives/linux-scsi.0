From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Tue, 23 Aug 2005 19:22:59 -0400
Message-ID: <430BAFD3.9000702@adaptec.com>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54975 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750784AbVHWXXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 19:23:02 -0400
In-Reply-To: <43095EB3.2020202@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

On 08/22/05 01:12, Douglas Gilbert wrote:
> I was surprised how much code needed changing.
> With MODE SELECT's issues with libata addressed
> various other SAT "extras" should be much easier
> to implement. That should make libata more attractive
> as a SAT layer for SAS LLDDs (that don't do it already
> in firmware).

Doug, how about never needing a SAT layer for SAS LLDDs
for ATA/ATAPI devices.

Would you object if I "give" you a "domain device" to which
you can send FISes (+ the packet if ATAPI) through
a SAM-4 intefrace: Execute Task + TMFs?

Jeff?

	Luben

