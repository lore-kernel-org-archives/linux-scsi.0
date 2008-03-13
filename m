From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] mpt fusion: Power Management fixes for MPT SAS PCI-E
	controllers-revised
Date: Thu, 13 Mar 2008 15:05:59 -0700
Message-ID: <20080313220559.GC5731@tree.beaverton.ibm.com>
References: <20080307104950.GA20496@lsil.com> <1205444515.2893.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43645 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbYCMWGF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 18:06:05 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2DM60RJ014781
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2008 18:06:00 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2DM60qr241860
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2008 18:06:00 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2DM60ld026746
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2008 18:06:00 -0400
Content-Disposition: inline
In-Reply-To: <1205444515.2893.77.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Prakash, Sathya" <sathya.prakash@lsi.com>, linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Thu, Mar 13, 2008 at 04:41:55PM -0500, James Bottomley wrote:

> This is supposed to be a bug fix patch to get suspend/resume working.
> Because you've made it dependent on the msi_enable patch, which is a
> feature enhancement, it still can't go in the scsi-rc-fixes tree.
> 
> Isn't it just best at this point to go with Darrick's patch for fixing
> 2.6.25 and 2.6.24?

I can say that I've tested my patch on a IBM Z30, x3200 M2, and x3350,
and all of them failed to resume before the patch and successfully
resumed afterwards.  Nobody from LSI has ever said "Don't do this, it's
dangerous/kills kittens/etc." and (afaik) it has sat around in -mm
without causing people trouble.  So, I agree with this plan to apply
mine as a stop-gap for .25 and .24, and we'll get to Sathya's version
for 2.6.26.

Unless, of course, somebody wants to extract just the part of Sathya's
patch (the clause starting with the "PCI-express errata" comment, I
presume?) and submit that?

--D
