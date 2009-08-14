From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 1/7] mpt2sas : Rescan topology from Interrupt context
 instead of work queue
Date: Fri, 14 Aug 2009 15:13:18 +0000
Message-ID: <1250262798.4021.13.camel@mulgrave.site>
References: <660360F4F2570145BD872F298951B17AB2BA9CA4@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54959 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbZHNPNY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2009 11:13:24 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17AB2BA9CA4@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Fri, 2009-08-14 at 09:05 -0600, Moore, Eric wrote:
> On Friday, August 14, 2009 9:00 AM,  James Bottomley wrote:
> 
> > Also, what exactly do these signoffs mean ... they're 
> > supposed to track
> > author and whose hands these patches have been through.  If Eric wrote
> > them, and you're just submitting them, I need a From: field at the
> > beginning to change the git authorship (and also the order of signoff
> > needs reversing).
> > 
> 
> I worked the fix back in May.   Kashyap is generating the patch's, and I'm reviewing them.

Reviewing or actually changing them?  Signed-off-by: is for alterations.
Reviewed-by: is for reviews.

James


