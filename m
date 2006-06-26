From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/6] libata: Add ata_host_flags
Date: Mon, 26 Jun 2006 21:54:26 +0100
Message-ID: <1151355266.27147.78.camel@localhost.localdomain>
References: <200606071625.k57GPrit014721@d01av01.pok.ibm.com>
	 <448CDEF3.1000703@pobox.com> <448DB360.8010504@us.ibm.com>
	 <44A02DD5.1030405@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:19373 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932103AbWFZUiZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 16:38:25 -0400
In-Reply-To: <44A02DD5.1030405@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Ar Llu, 2006-06-26 am 13:56 -0500, ysgrifennodd Brian King:
> Jeff, any further thoughts about this? I had been trying to avoid having
> any host_set type of data for the SAS usage of libata in part due to
> not seeing a need and also due to a comment Bartlomiej made a while back:
> 
> http://marc.theaimsgroup.com/?l=linux-ide&m=112842136431977&w=2

Well if anything we seem to be going the other way, in order to get
things like Simplex working with legacy mode the legacy setup needs the
two ports on the same host_set with differing IRQ/ports.

Alan

