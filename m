From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: Wed, 4 Feb 2004 16:33:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFCBD64150.59466282-ON87256E31.0002462C-88256E31.0002E095@us.ibm.com>
References: <1075936996.2029.131.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:56461 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265146AbUBEAdO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 19:33:14 -0500
In-Reply-To: <1075936996.2029.131.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>

> On Wed, 2004-02-04 at 18:12, Bryan Henderson wrote:
> > But it doesn't identify the "device" as Linux defines a device. 
Setting
> > aside multiple paths for the moment, a Linux sd device corresponds to 
an
> > FCP logical unit, and the WWN identifies an FCP target (aka physical 
unit).
> > I.e. where a physical unit has multiple logical units, multiple linux 
sd
> > devices can have the same WWN.
> 
> Actually, the SPC-3 (rev 16) section 7.6.4.1 does say the Device
> Identification VPD Page ... [shall apply] to the logical unit.
> 
> Of course, not all devices obey this, as you say, but still.

I stand corrected.  Upon further investigation, I realize that I confused 
WWN with WWNN.  WWN (worldwide name) is a generic term referring to, well, 
world wide names.  There are at least 3 WWNs in FCP systems:  WWPN 
(worldwide port name) to identify a port in an FC network, WWNN (worldwide 
node name) to identify a node in an FC network, which corresponds to an 
FCP target (physical unit), and a logical unit WWN, which I have seen 
called LUSN (Logical Unit Serial Number), but now I see others calling it 
the LU WWN and logical unit name too.

I haven't see any relevant standards, but I'll take your word for it that 
SPC-3 calls the VPD field in question a 'WWN' and because it's a VPD page 
for a logical, that means it is the LU WWN.

