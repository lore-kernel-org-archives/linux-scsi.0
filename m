From: scameron@beardog.cce.hp.com
Subject: Re: Question about scsi error handling and LLD
Date: Tue, 19 Aug 2014 12:59:28 -0500
Message-ID: <20140819175928.GL19666@beardog.cce.hp.com>
References: <20140819153051.GG19666@beardog.cce.hp.com> <1408468572.7095.11.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:55657 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaHSSAs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 14:00:48 -0400
Received: from g6t1525.atlanta.hp.com (g6t1525.atlanta.hp.com [15.193.200.68])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 0A9E37429D
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2014 18:00:48 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <1408468572.7095.11.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, elliott@hp.com, scameron@beardog.cce.hp.com

On Tue, Aug 19, 2014 at 12:16:12PM -0500, James Bottomley wrote:
> On Tue, 2014-08-19 at 10:30 -0500, scameron@beardog.cce.hp.com wrote:
> > 
> > Is it permitted for a LLD to call scsi_done() for a command which
> > has been or is attempting to be aborted via the LLD abort error handler
> > function?
> > 
> > I am looking at the scsi mid layer code, and I'm a bit confused.
> 
> Hannes asked a similar question; does this help:
> 
> http://marc.info/?l=linux-scsi&m=140267838320488
[...]

Yes, that helps.  Thanks.

-- steve

