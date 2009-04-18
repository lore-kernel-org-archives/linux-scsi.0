From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: ipr_remove() marked __devexit
Date: Fri, 17 Apr 2009 22:05:07 -0400
Message-ID: <1240020307.5763.1.camel@mulgrave>
References: <1237839145.13011.54.camel@zeppelin.austin.ibm.com>
	 <1239995314.6143.1.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60926 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbZDRDuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2009 23:50:12 -0400
In-Reply-To: <1239995314.6143.1.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-04-17 at 16:08 -0300, Kleber S. Souza wrote:
> Hi,
> 
> Any comments on this patch? 
> 
> It was acked by Brian King, do I need to do anything else to get it
> accepted?

No ... looks OK to me:

> Thanks,
> Kleber
> 
> On Mon, 2009-03-23 at 17:12 -0300, Kleber Sacilotto de Souza wrote:
> > Marking the ipr clean up function ipr_remove() as __devexit and using
> > __devexit_p() macro in its address reference.
> > 
> > 
> > Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.ibm.com>
> > Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>

Just explain this signoff?  signed-off-by is supposed to document the
hands the patch has passed through ... it's not clear what Breno Leitao
has to do with the transmission of this patch.

James


