From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Transport Attributes -- attempt#4
Date: Mon, 23 Feb 2004 21:58:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224055828.GA503530@sgi.com>
References: <20040120215645.GG15871@localhost> <1077581832.1833.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:59361 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S262174AbUBXF6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 00:58:37 -0500
Content-Disposition: inline
In-Reply-To: <1077581832.1833.21.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Martin Hicks <mort@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 23, 2004 at 06:17:11PM -0600, James Bottomley wrote:
> 
> OK, I finally found time to look at all this and try it out.
> 
> My big objection is still that the scsi mid-layer needs to know about
> the transports.  In testing, I recoded this so that no mid-layer
> transport knowledge is necessary (patch attached).  I didn't opt for a
> transport registration API in the mid-layer, but I could see that such a
> thing might have been a better solution.

James, was scsi/scsi_transport.h supposed to be patched also?
There is a new "size" member of the scsi_transport_template
structure, but no patch to the data structure itself.  Did you
replace attributes with size?

Also, Martin is on vacation this week, I believe, so he probably
won't respond until next week.

thanks

jeremy
