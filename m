From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: 21 Jun 2004 12:43:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087839828.2079.60.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5704925040@exa-atlanta>
	<20040621172303.GA12308@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:13206 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266352AbUFURn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:43:58 -0400
In-Reply-To: <20040621172303.GA12308@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: Eric Dean Moore <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-06-21 at 12:23, viro@parcelfarce.linux.theplanet.co.uk
wrote:
> On Mon, Jun 21, 2004 at 01:09:43PM -0400, Moore, Eric Dean wrote:
> > Somebody had submitted this change in the last week,
> > along with the comment in that patch:
> > 
> > "The only way crap below could work..."
> 
> Yes?  Care to take a look at your definition of S64?  Now think for a moment
> what it will produce on a big-endian box.

Annotating someone else's maintained code base with a comment implying
that it's 'crap' isn't appropriate behaviour (however sincerely you
believe it to be true).

Now that we've done the name calling how about we remove the commant and
look at fixing all of this correctly.

James


