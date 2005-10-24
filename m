From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC] use struct scsi_lun in generic code
Date: Tue, 25 Oct 2005 08:40:27 +1000
Message-ID: <435D62DB.1080205@torque.net>
References: <20051023043301.GA22615@havoc.gtf.org> <20051024152730.GA28341@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:1504 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751362AbVJXWjX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:39:23 -0400
In-Reply-To: <20051024152730.GA28341@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:

<snip>

> Note that current SAM (sam4r02) sort of allows for different sized LUNs,
> it says "A logical unit number shall contain 64 bits or 16 bits, with the
> size being defined by the SCSI transport protocol.  For SCSI transport
> protocols that define 16-bit logical unit numbers, the two bytes shall be
> formatted as described for the FIRST LEVEL ADDRESSING field (see table 5
> in 4.9.5)."

The "or 16 bits" was added to SAM after it was pointed
out that a new standard was recently approved that mandated
16 bit luns. That is SBP-3 (i.e. IEEE 1394 transport). All
other "current" transports shown in sam4r03.pdf, Annex A
are 64 bits (with a note on "SPI-5").

Aside: Annex A shows SPI-5 (Ultra 640) as the "current"
SPI standard. This is an example of where standards (or
drafts) diverge from reality :-)

Doug Gilbert
