From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: 06 Jun 2003 12:04:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054915493.1778.36.camel@mulgrave>
References: <1054742495.1674.18.camel@mulgrave>	<20030604165146.GA1426@beaverton.ibm.com
	>	<1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org>
		<3EE0B316.4060207@rogers.com> <1054913984.1778.31.camel@mulgrave>
	<3EE0B8D8.4020909@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:64005 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261939AbTFFPwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 11:52:17 -0400
In-Reply-To: <3EE0B8D8.4020909@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 2003-06-06 at 11:52, Luben Tuikov wrote:
> So SCSI Core _has_ decided to know about ULP (block, tape, optical).
> 
> Unless we (SCSI Core) generate those, it's a pickle to decide
> which are ``special'' enough commands.  I think that we'll see
> more user space drivers controlling devices via sg sending
> commands to the device for exactly those kinds of problems...
> Else the burden on SCSI Core will/might be too great.

By "special" I mean requests marked REQ_SPECIAL.  These are generated
either internally or via SCSI_IOCTL_SEND_COMMAND.

James


