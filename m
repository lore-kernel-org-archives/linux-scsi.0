From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Try READ CAPACITY 16 first for all SCSI-3 devices
Date: Wed, 25 Feb 2009 14:43:29 -0800
Message-ID: <1235601810.19035.5.camel@localhost.localdomain>
References: <20081223164703.GB19967@parisc-linux.org>
	 <yq1sko4y7e4.fsf@sermon.lab.mkp.net>
	 <20081231135014.GE2002@parisc-linux.org>
	 <20081231135142.GF2002@parisc-linux.org>
	 <20090223215137.GA13649@parisc-linux.org>
	 <1235600621.19035.3.camel@localhost.localdomain>
	 <20090225223110.GY16891@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38119 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475AbZBYWnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 17:43:35 -0500
In-Reply-To: <20090225223110.GY16891@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-02-25 at 15:31 -0700, Matthew Wilcox wrote:
> On Wed, Feb 25, 2009 at 02:23:41PM -0800, James Bottomley wrote:
> > On Mon, 2009-02-23 at 14:51 -0700, Matthew Wilcox wrote:
> > > Any reason this patch hasn't been merged into scsi-misc yet?
> > 
> > There was a problem with it I drew your attention to here:
> > 
> > http://marc.info/?l=linux-scsi&m=123308499405071
> 
> This was the updated version, sent on Dec 31, not the version you
> commented on on Dec 23.

Oh, sorry, missed the update.

James


