From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] Optionally disable QAS in MPT Fusion spi driver
Date: Thu, 15 Jun 2006 09:21:02 -0700
Message-ID: <1150388463.3143.47.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70199848@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:12749 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030788AbWFOQVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 12:21:34 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70199848@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Patterson <andrew.patterson@hp.com>, linux-scsi@vger.kernel.org

On Thu, 2006-06-15 at 09:31 -0600, Moore, Eric wrote:
> James said it was okay for having this done in lld, instead
> of transport.  I'm sure both me and Andrew would be happy 
> the same if the transport handled this.  
> Is that possible for you to look into this, or James?

Before we go the lld route, could someone just assure me this is a
fusion specific problem.  Andrew, could you attach the same drives to
another QAS LLD, like aic79xx and verify the problem doesn't recur?

If it's something drive specific, we probably need more of a blacklist
in the spi transport class.

James


