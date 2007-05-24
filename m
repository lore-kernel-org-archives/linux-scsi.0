From: Christoph Lameter <clameter@sgi.com>
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
Date: Thu, 24 May 2007 10:00:08 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705240959310.28086@schroedinger.engr.sgi.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
 <1180018752.3692.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32939 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751929AbXEXRAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 13:00:10 -0400
In-Reply-To: <1180018752.3692.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Aubrey Li <aubreylee@gmail.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Thu, 24 May 2007, James Bottomley wrote:

> > Going to ensure that we have a 31 bit (not 32 bit) physical address?
> 
> No, unfortunately.  Implementing kmalloc_mask() and kmalloc_dev() was
> something I said I'd do ... about two years ago.

Tell me more about these ideas. 
