From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Transport Attributes -- attempt#4
Date: 24 Feb 2004 09:02:56 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077634979.1827.7.camel@mulgrave>
References: <20040120215645.GG15871@localhost>
	<1077581832.1833.21.camel@mulgrave>  <20040224055828.GA503530@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:11960 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262264AbUBXPDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 10:03:21 -0500
In-Reply-To: <20040224055828.GA503530@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Martin Hicks <mort@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-02-23 at 23:58, Jeremy Higdon wrote:
> James, was scsi/scsi_transport.h supposed to be patched also?
> There is a new "size" member of the scsi_transport_template
> structure, but no patch to the data structure itself.  Did you
> replace attributes with size?

Well, not really.  The patch I provided is a sketch only of what I want
done.  It compiles and works on the 53c700 which is where I tested it.

Really, I just want transport and core separated and transport
attributes to be fixed (so there's some way of defining a transport
private API for updating them).

Even with just offset and period as the transport attributes for SPI,
that gives enough to move domain validation out of all the drivers into
the SPI transport layer.

> Also, Martin is on vacation this week, I believe, so he probably
> won't respond until next week.

Yes, I know, It's just that I've been promising to look at this for
weeks, so I didn't want to delay any further.

James


