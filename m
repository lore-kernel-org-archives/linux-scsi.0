From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: 04 Feb 2004 18:23:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075936996.2029.131.camel@mulgrave>
References: <OFB4AE9EAB.C15E2C56-ON87256E30.007E8F0D-88256E30.007F5E0C@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:19594 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264887AbUBDXXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 18:23:21 -0500
In-Reply-To: <OFB4AE9EAB.C15E2C56-ON87256E30.007E8F0D-88256E30.007F5E0C@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>

On Wed, 2004-02-04 at 18:12, Bryan Henderson wrote:
> But it doesn't identify the "device" as Linux defines a device.  Setting
> aside multiple paths for the moment, a Linux sd device corresponds to an
> FCP logical unit, and the WWN identifies an FCP target (aka physical unit).
> I.e. where a physical unit has multiple logical units, multiple linux sd
> devices can have the same WWN.

Actually, the SPC-3 (rev 16) section 7.6.4.1 does say the Device
Identification VPD Page ... [shall apply] to the logical unit.

Of course, not all devices obey this, as you say, but still.

James


