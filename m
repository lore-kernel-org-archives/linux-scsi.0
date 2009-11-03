From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] pcmraid: fix endianness problems
Date: Tue, 03 Nov 2009 15:31:43 -0600
Message-ID: <1257283903.2454.3.camel@mulgrave.site>
References: <1257268514.9427.4.camel@mulgrave.site>
	 <alpine.LNX.1.10.0911031116170.13870@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbZKCVbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 16:31:44 -0500
In-Reply-To: <alpine.LNX.1.10.0911031116170.13870@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-11-03 at 11:29 -0800, Anil Ravindranath wrote:
> James,
> 
> Yes. We can remove these spurious cpu_to_le32 wrappers for 8 bits.
> I had already submitted a patch dated: Sep 24 to address this. The subject 
> of the mail/patch was:
> PATCH 1/1] pmcraid: Fix ppc64 driver build for using cpu_to_le32 on U8 
> data type

Sorry ... found it now.  I'll add it to the list for scsi-misc.

Thanks,

James


