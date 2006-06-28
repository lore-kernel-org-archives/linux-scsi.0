From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] reroll of sas ports patch
Date: Wed, 28 Jun 2006 13:36:21 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701BDE9E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10692 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751094AbWF1TgX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 15:36:23 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, June 28, 2006 1:35 PM, James Bottomley wrote: 
> 
> On Wed, 2006-06-28 at 13:28 -0600, Moore, Eric wrote:
> > Thanks, but can we have a better way in keeping track of the unique
> > expander numbers than using rphy->scsi_target_id?  I get 
> confused when
> > I see the target id there in the code.
> 
> Um, what do you suggest?  just renaming the variable?
> 

Yes, since its really not the target id.  
