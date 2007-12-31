From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: don't use made up error codes
Date: Mon, 31 Dec 2007 15:34:34 -0600
Message-ID: <1199136874.3110.1.camel@localhost.localdomain>
References: <1199039851.5380.4.camel@localhost.localdomain>
	 <20071231212553.GD6767@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58548 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbXLaVel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 16:34:41 -0500
In-Reply-To: <20071231212553.GD6767@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


On Mon, 2007-12-31 at 13:25 -0800, Darrick J. Wong wrote:
> On Sun, Dec 30, 2007 at 12:37:31PM -0600, James Bottomley wrote:
> > This is bad for two reasons:
> > 
> >      1. If they're returned to outside applications, no-one knows what
> >         they mean.
> >      2. Eventually they'll clash with the ever expanding standard error
> >         codes.
> > 
> > The problem error code in question is ETASK.  I've replaced this by
> > ECOMM (communications error on send) a network error code that seems to
> > most closely relay what ETASK meant.
> 
> Yay, cleanups :)

Don't get your hopes up ... this was just one that unavoidably crossed
my attention path while I was doing something else.  I'm not going out
looking for these things ... mainly for fear of finding them in large
quantities.

James


