From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: IP over FC and qlogic workarounds in fusion
Date: Mon, 30 Aug 2004 18:29:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704F631BE@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:25836 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S265044AbUH3WaK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 18:30:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

Here is feedback from Stephen Shirron, co-worker here
at LSI Logic:

To my knowledge QLogic has never even acknowledged that
they had a bug.  In my opinion it is not
safe to remove this code.  We do have versions of the FC
firmware that work around this QLogic bug, but it's hard
to know if the entire field is populated.  It would not
be good to introduce a regression that decreases our
interoperability.


On Saturday, August 28, 2004 1:37 PM, Christoph Hellwig wrote:
> 
> Does anyone know whether modern qlogic firmwares fixed the
> QLOGIC_NAA_WORKAROUND in mptlan.c?  I'd love to get rid of it 
> so fusion
> could use the little bit of common ip over fc infrastructure we have..
> 
