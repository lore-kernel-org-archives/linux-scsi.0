From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Thu, 05 Nov 2009 09:44:15 -0600
Message-ID: <1257435855.2753.43.camel@mulgrave.site>
References: <4AF17AD3.6060909@Calva.COM>
	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM>
	 <1257350834.2697.52.camel@mulgrave.site>  <4AF1A7E7.7070307@Calva.COM>
	 <1257351654.2697.55.camel@mulgrave.site> <4AF1C172.6080509@Calva.COM>
	 <4AF29DC2.2070803@Calva.COM>  <4AF2EFA4.4080004@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbZKEPoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 10:44:16 -0500
In-Reply-To: <4AF2EFA4.4080004@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-11-05 at 16:30 +0100, John Hughes wrote:
> John Hughes wrote:
> > One problem with the patch is that, since I don't have a page 7 (bay 
> > names) it's using the "enclosure component index" as the name, and 
> > that (at least for me) seems to be an index starting from zero, where 
> > my bays are numbered from one.
> >
> > sg_ses shows a "bay number", I think I'll try to make the patch look 
> > for the bay number and make the name something like "bay-nn" if there 
> > is a bay number.
> Doesn't work because bays without a device don't show a bay number and 
> hot-plugging a device doesn't make things change dynamically.

Let me dig around in the standards.  My instinct from the implementation
notes was that page 7 was more likely to be present than page 10, so
that's how I coded it.  There may still be a way to get the slot number
in a persistent fashion without the actual page telling you this.

> Buggeration.

Welcome to the wonderful world of SCSI standards implementation.

James


