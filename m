From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 10/30] megaraid: add CERC_ATA100 support
Date: Fri, 10 Aug 2007 17:58:34 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229BF18DD@NAMAIL2.ad.lsil.com>
References: <20070810153600.7cd204b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43394 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbXHJX6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 19:58:52 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070810153600.7cd204b0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, tkrah@fachschaft.imn.htwk-leipzig.de, protasnb@gmail.com, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

 

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Friday, August 10, 2007 3:36 PM
> To: Patro, Sumant
> Cc: James.Bottomley@steeleye.com; linux-scsi@vger.kernel.org; 
> tkrah@fachschaft.imn.htwk-leipzig.de; protasnb@gmail.com; 
> Kolli, Neela; Yang, Bo
> Subject: Re: [patch 10/30] megaraid: add CERC_ATA100 support
> 
> On Fri, 10 Aug 2007 16:20:54 -0600
> "Patro, Sumant" <Sumant.Patro@lsi.com> wrote:
> 
> > ID being added is already supported in megaraid_mbox driver.
> 
> umm, why should that cause us to avoid supporting it in the 
> old driver?
> 

With overlapping ids it will be indeterminate which one (megaraid
legacy/mbox) claims the device.
All overlapping IDS were removed from megaraid legacy/megaraid_mbox
driver about 2 years back.  

--Sumant
