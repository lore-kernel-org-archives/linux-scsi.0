From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: 05 Oct 2004 12:18:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096996724.2064.56.camel@mulgrave>
References: <OF2154D688.D97183DA-ONC1256F24.005BD3E3-C1256F24.005EE95C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54667 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269091AbUJERSq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 13:18:46 -0400
In-Reply-To: <OF2154D688.D97183DA-ONC1256F24.005BD3E3-C1256F24.005EE95C@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 12:10, Martin Peschke3 wrote:
> now that there is more and more stuff handed over to transport classes,
> would it be feasible to put LUN there as well, as its form appears to be
> transport specific as well? (e.g. 64 bit for FC while other transports
> may be unable to convey 64 bit LUNs)

Well, I'm not sure about that, primarily because the LUN specifications
in the standards aren't transport specific.

> I see that this particular patch is not exactly what was needed to achieve
> this, because at the time of the evaluation INQUIRY data the LUN has
> already been adapted to the way LUNs are stored in scsi_device.
> 
> I am also not sure yet how this approach would go with REPORT_LUNS,
> which returns 64 bit LUNs for all transports. But for everybody interested
> in 64 bit LUNs, it would certainly clean things up.

Yes, that's another reason to make it transport specific.  Even SPI code
has to understand 64 bit LUN returns.

James


