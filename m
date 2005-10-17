From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] mptsas: support link error attributes[2 round] - and phy_reset attributes
Date: Mon, 17 Oct 2005 13:53:57 +0100
Message-ID: <20051017125357.GA29491@infradead.org>
References: <200510121816.02479.Eric.Moore@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12258 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932303AbVJQMyB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 08:54:01 -0400
Content-Disposition: inline
In-Reply-To: <200510121816.02479.Eric.Moore@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 12, 2005 at 06:16:02PM -0600, Moore, Eric Dean wrote:
> This patch applies ontop of 2.6.14-rc4
> and two patches previous posted by Christoph
> 
> (1) [PATCH] mptsas: support link error attributes
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112716006932685&w=2
> 
> (2)  [PATCH] scsi_transport_sas: support link error attributes
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112716000904268&w=2
> 
> This attached patch changelog as follows:
> 
> (1) fix?s the proper phy_identifier attribute to be set properly
> so link_attributes returns correct values from firmware.
> 
> (2) Only link_attributes work for hba attached phys. Its not implemented
> for expanders.
> 
> (3) Add phy link_reset and hard_reset support.  These work for
> hba attached phys, not for expanders. This was a patch previously
> provided by Christoph - added support in scsi_transport_sas.

Except for some whitespace changes and some odd bits about the reply
handle this looks good.  But it really needs to be split up, we should
try to get the phy identifier fix into 2.6.14 if possible, and the
transport class bits needs to be separate from the mptsas changes for
the link reset.  I'll resend some split-up patches.

