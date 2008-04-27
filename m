From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [patch 02/10] Dell CERC support for megaraid_mbox
Date: Sun, 27 Apr 2008 13:14:26 -0500
Message-ID: <1209320066.3801.24.camel@localhost.localdomain>
References: <9738BCBE884FDB42801FAD8A7769C26502130B8E@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36058 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758288AbYD0SOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 14:14:33 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26502130B8E@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, hare@suse.de, "Patro, Sumant" <Sumant.Patro@lsi.com>

On Tue, 2008-04-22 at 13:44 -0600, Yang, Bo wrote:
> Hannes,
> 
> Our FW team give me the feedback said: LSI never release CERC firware
> version >=6.62.  I have asked our DELL contactor to check with DELL if
> DELL know who made this release.  I will update you as soon as I get the
> words from DELL.  Also if you have the information regarding to the CERC
> FW 6.62 release, can you pass them to me?  I need to know the details
> about this release.

So, the fact that it shouldn't have been released doesn't really fix the
problem that it seems to be out in the field and causing problems.  Can
I take it that the proposed patch is an acceptable fix?  Especially if
LSI hasn't officially released it, the proposed patch shouldn't affect
any LSI sanctioned drivers.

James


