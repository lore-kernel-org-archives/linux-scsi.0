From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [patch 02/10] Dell CERC support for megaraid_mbox
Date: Mon, 28 Apr 2008 16:11:34 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26502179409@NAMAIL1.ad.lsil.com>
References: <1209320066.3801.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58725 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965939AbYD1WM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 18:12:27 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1209320066.3801.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, hare@suse.de, "Patro, Sumant" <Sumant.Patro@lsi.com>

James,

Agree with you --ACK.

Thanks.

Bo Yang 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Sunday, April 27, 2008 2:14 PM
To: Yang, Bo
Cc: akpm@linux-foundation.org; linux-scsi@vger.kernel.org; hare@suse.de;
Patro, Sumant
Subject: RE: [patch 02/10] Dell CERC support for megaraid_mbox

On Tue, 2008-04-22 at 13:44 -0600, Yang, Bo wrote:
> Hannes,
> 
> Our FW team give me the feedback said: LSI never release CERC firware 
> version >=6.62.  I have asked our DELL contactor to check with DELL if

> DELL know who made this release.  I will update you as soon as I get 
> the words from DELL.  Also if you have the information regarding to 
> the CERC FW 6.62 release, can you pass them to me?  I need to know the

> details about this release.

So, the fact that it shouldn't have been released doesn't really fix the
problem that it seems to be out in the field and causing problems.  Can
I take it that the proposed patch is an acceptable fix?  Especially if
LSI hasn't officially released it, the proposed patch shouldn't affect
any LSI sanctioned drivers.

James


