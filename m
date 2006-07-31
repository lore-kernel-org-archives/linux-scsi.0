From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Fix scsi/scsi_transport.h compile error
Date: Mon, 31 Jul 2006 17:26:18 +0200
Message-ID: <44CE211A.2030205@s5r6.in-berlin.de>
References: <200607310943.25384.eike-kernel@sf-tec.de> <20060731131446.GB6087@athena.road.mcmartin.ca> <44CE07AA.9030202@s5r6.in-berlin.de> <20060731143839.GC6087@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33205 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1030191AbWGaP3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 11:29:46 -0400
In-Reply-To: <20060731143839.GC6087@athena.road.mcmartin.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Kyle McMartin wrote:
> On Mon, Jul 31, 2006 at 03:37:46PM +0200, Stefan Richter wrote:
>> That function accesses members of the struct, i.e. the compiler needs to
>> know offsets into struct scsi_device at this point. Therefore it needs
>> the definition, not a declaration.
> 
> Odd, ISTR that it only needed to be defined at the point the inline was
> used. Oh well, my bad.

One would think so. Maybe it depends on the compiler version.

(Actually I haven't checked scsi_transport.h myself but I recall fixing
another header with the same issue. Although I don't remember anymore
whether it lead to a warning or to an error and which gcc version I used
then.)
-- 
Stefan Richter
-=====-=-==- -=== ==---
http://arcgraph.de/sr/
