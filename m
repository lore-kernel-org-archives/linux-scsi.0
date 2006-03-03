From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/2] mptspi: Add transport class Domain Validation
Date: Fri, 3 Mar 2006 12:41:54 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F32795C@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9388 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751351AbWCCTmF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 14:42:05 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: hch@infradead.org

On Wednesday, March 01, 2006 8:03 AM, James Bottomley wrote: 
> 
> 
> Still to be done is to plug back the extra parameter setting and DV
> pieces on reset and hotplug.

Are you planning to complete this, or is it back on my plate?  This
needs
to be completed before this is merged into mainline.

Can you rebase your previous raid transport support patch's for spi
against
the scsi_misc tree, and then repost.

It appears this dv patch is there in the scsi-misc tree as of this
morning.
I'm in the process of providing a patch with expander hot add/remove
support.
So I'm working today on rebasing my code over your lastest scsi-misc
tree.

Thanks
Eric Moore



