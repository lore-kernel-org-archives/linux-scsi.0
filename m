From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] reroll of sas ports patch
Date: Wed, 28 Jun 2006 18:18:48 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701BDF8D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43751 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751837AbWF2ASu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 20:18:50 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, June 28, 2006 1:47 PM, James Bottomley wrote: 

> On Wed, 2006-06-28 at 13:36 -0600, Moore, Eric wrote:
> > Yes, since its really not the target id.  
> 
> Sure .. it's one of Christoph's originals ... I just reused it for
> expanders because it made sense.  It's really just a general index
> count.
> 
> Just find a nicer name and send a patch.
> 


I'm getting ready to repost a new mptsas patch to use zero
based port ids for each expander.  Thanks fixing the end_device
bus_id.  

Also, for some reason, I'm not seeing the hang from sas_rphy_delete ->
sas_remove_children.  I'm not sure if it was a bad compile or card.  
You new patch is working fine right now, after I recompiled and shifted
cards.

Can you pls test with the set of mptsas patchs I posted yesterday, and
the
one I'm getting ready to post?

Eric
