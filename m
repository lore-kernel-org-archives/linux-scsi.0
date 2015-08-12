From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V5 11/11] [SCSI] aacraid: Requests at least 2 MSIx in
 pci_enable_msix_range()
Date: Wed, 12 Aug 2015 11:29:00 -0700
Message-ID: <1439404140.2825.61.camel@HansenPartnership.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <55B0E429.2090805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52739 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbbHLS3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 14:29:03 -0400
In-Reply-To: <55B0E429.2090805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: rajinikanth.pandurangan@pmcs.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com


> On 22.7.2015 18:49, rajinikanth.pandurangan@pmcs.com wrote:
> > From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
> > 
> > Description:
> >         In MSIx mode, we need at least 2 vectors.
> > 
> > Changes from V4:
> >       Newly created for V5 based on review comment.
> > 
> > Signed-off-by: Rajinikanth Pandurangan
> <rajinikanth.pandurangan@pmcs.
> 
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>

I'm confused by your [PATCH v6] posting: where did this patch go ... do
you want it dropped or did you just forget to include it?

James


