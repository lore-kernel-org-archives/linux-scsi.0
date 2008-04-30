From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 02/10] scsi: fix integer as NULL pointer warnings
Date: Wed, 30 Apr 2008 17:54:38 -0500
Message-ID: <1209596078.3774.38.camel@localhost.localdomain>
References: <1209593020.24729.112.camel@brick>
	 <1209594551.3774.37.camel@localhost.localdomain>
	 <1209594888.24729.130.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40134 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592AbYD3Wym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2008 18:54:42 -0400
In-Reply-To: <1209594888.24729.130.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-04-30 at 15:34 -0700, Harvey Harrison wrote:
> On Wed, 2008-04-30 at 17:29 -0500, James Bottomley wrote:
> > On Wed, 2008-04-30 at 15:03 -0700, Harvey Harrison wrote:
> > > drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
> > > drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
> > > drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer
> 
> > The flashpoint initialiser changes look wrong:  {0} is a conventional
> > notation for zero initialise this structure.  Sparse should probably be
> > taught to recognise that.
> 
> Actually, looking closer, should this be initialized at all?  Can we
> just remove the initialization here and let them end up in .bss?

Yes, but the conventional initialiser doesn't change that (as in zero
initialise a static and it ends up in bss anyway).

James


