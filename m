From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: 05 Feb 2004 10:10:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075993831.1756.8.camel@mulgrave>
References: <OFCBD64150.59466282-ON87256E31.0002462C-88256E31.0002E095@us.ibm.com>
	<1075989386.19275.1895.camel@bianchi.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:6618 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263584AbUBEPLv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 10:11:51 -0500
In-Reply-To: <1075989386.19275.1895.camel@bianchi.boston.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Tom Coughlan <coughlan@redhat.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>

On Thu, 2004-02-05 at 08:56, Tom Coughlan wrote:
> Each identifier on the SPC-3 Device Identification VPD page (page 83)
> has an "association" field, with one of the following values:
> 
> - The IDENTIFIER field is associated with the addressed logical unit. 
> - The IDENTIFIER field is associated with the SCSI target port that
> received the request. 
> - The IDENTIFIER field is associated with the SCSI target device that
> contains the addressed logical unit. 
> 
> So, an identifier on page 83 may be either an LU WWN, WWPN, or a WWNN. 

Actually, this isn't an either/or, the page may contain a list. 
However, the standard is very clear (7.6.4.11.3) that each LUN that is
not a well known LUN shall have at least one identifier of association 0
(Logical Unit Identifier).

> We need to check the association field, and use the identifier
> appropriately, and we need to insist that storage vendors implement it
> correctly.

I agree, but I see this as a userspace issue.

James


