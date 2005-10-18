From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH ] mptsas: support link error attributes[2 round] - and
	 phy_reset attributes
Date: Tue, 18 Oct 2005 07:57:15 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C048719B2@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5761 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750734AbVJRN6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 09:58:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux scsi <linux-scsi@vger.kernel.org>

On Monday, October 17, 2005 6:54 AM, Christoph Hellwig wrote: 
> On Wed, Oct 12, 2005 at 06:16:02PM -0600, Moore, Eric Dean wrote:
> > This patch applies ontop of 2.6.14-rc4
> > and two patches previous posted by Christoph
> > 
> > (1) [PATCH] mptsas: support link error attributes
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112716006932685&w=2
> > 
> > (2)  [PATCH] scsi_transport_sas: support link error attributes
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112716000904268&w=2
> > 
> > This attached patch changelog as follows:
> > 
> > (1) fix?s the proper phy_identifier attribute to be set properly
> > so link_attributes returns correct values from firmware.
> > 
> > (2) Only link_attributes work for hba attached phys. Its 
> not implemented
> > for expanders.
> > 
> > (3) Add phy link_reset and hard_reset support.  These work for
> > hba attached phys, not for expanders. This was a patch previously
> > provided by Christoph - added support in scsi_transport_sas.
> 
> Except for some whitespace changes and some odd bits about the reply
> handle this looks good.  But it really needs to be split up, we should
> try to get the phy identifier fix into 2.6.14 if possible, and the
> transport class bits needs to be separate from the mptsas changes for
> the link reset.  I'll resend some split-up patches.
>

Thanks for the other post; e.g. "fix phy identifiers".

For the link/phy reset support, were you planning to submit
seperate patch's for this, or were you wanting me to handle that?

Eric Moore  
