From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: scsi device attributes
Date: 22 Oct 2004 09:00:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098450017.2017.19.camel@mulgrave>
References: <Pine.LNX.4.60.0410212223120.7042@poirot.grange>
	<20041022124007.GC4201@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29091 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S271304AbUJVNAZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 09:00:25 -0400
In-Reply-To: <20041022124007.GC4201@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-10-22 at 08:40, Matthew Wilcox wrote:
> How about something more along the following lines?  I haven't converted
> sym2 to the generic queue code yet, so it's untested (and is obviously
> broken because nothing initialises max_queue_depth).

Yes, I was considering something like this.  The original queue code in
53c700 was designed as an example of how to do attribute overrides. 
However, there needs to be a callback into the LLD to tell it that the
queue is being overriden (and allow a veto for depth increases).  I'll
look at adding the extra pieces.

James


