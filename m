From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 6/9] mpt fusion: error recovery improvements,andsynchronizing internal commands
Date: Tue, 25 Sep 2007 12:22:56 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709D940E@NAMAIL4.ad.lsil.com>
References: <1190741527.3345.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51173 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbXIYSXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 14:23:01 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1190741527.3345.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, September 25, 2007 11:32 AM,  James Bottomley  wrote:
 
> > Youve rejected the error recovery patchs, which is fair enough.  
> 
> Just the separation ... the actual patch looks OK.
> 

I'll will continue working to separate the "error recovery
improvements:" into smaller feature add, but will take some time.   I
want some constructive feedback, and too big of patch is deterring some
people from looking at it.

Thanks,
Eric 
