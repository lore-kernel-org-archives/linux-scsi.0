From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 21 Jun 2007 18:54:46 +0200
Message-ID: <467AAD56.4070403@s5r6.in-berlin.de>
References: <200706191025.30986.swen@vnet.ibm.com> <20070619171217.GA30099@infradead.org> <1182307586.10507.7.camel@mulgrave.il.steeleye.com> <20070621150308.GA29643@schmichrtp.de.ibm.com> <467AAB55.9040306@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57555 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbXFUQyz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 12:54:55 -0400
In-Reply-To: <467AAB55.9040306@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

> the SCSI midlayer H:C:T:L

NB, the H, C, T, and L therein are implementation-defined things and not
to be mistaken for actual SCSI identifiers or names.
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/
