From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC
	attribute  structure in sysfs
Date: Sat, 11 Apr 2009 10:56:07 -0700
Message-ID: <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40215 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757328AbZDKR41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Apr 2009 13:56:27 -0400
In-Reply-To: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, pjones@redhat.com, konradr@linux.vnet.ibm.com, ketuzsezr@darnok.org, "Vishnu V. Mandyam" <vishnu@chelsio.com>

On Sat, 2009-04-11 at 18:59 +0530, Ashutosh Naik wrote:
> This patch fixes the display of a few fields in the iBFT NIC attribute
> structure in sysfs.
> 
> Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
> Signed-off-by: Vishnu V<vishnu@chelsio.com>

What do these signoffs mean?  Traditionally you sign off on a patch if
it passed through your hands, so if this is a patch from Vishnu which
you're sending in, they need to be in reverse order (and a From: for
Vishnu).

The second question is who picks this up?  The drivers/firmware
directory doesn't seem to have a dedicated tree, so I can take this
through the SCSI tree if required or Andrew can take it through -mm.

James


