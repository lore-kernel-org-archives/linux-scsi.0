From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/10][RFC] linux-iscsi driver
Date: Tue, 11 Jan 2005 09:47:43 -0600
Message-ID: <1105458463.3975.17.camel@mulgrave>
References: <41E30855.9050203@cs.wisc.edu>
	 <20050110232442.GB10138@infradead.org> <1105404318.4477.18.camel@mulgrave>
	 <20050111095920.GA18119@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60806 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262807AbVAKPsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 10:48:15 -0500
In-Reply-To: <20050111095920.GA18119@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-11 at 09:59 +0000, Christoph Hellwig wrote:
> > For the time being I think iscsi-sfnet will do since there's still one
> > other possible linux iscsi stack around.  And we would probably have
> > called our networking code ipv4-swansea if we also had an ipv4-bsd or
> > something else one could use.
> > 
> > In the long run, there will be only a single iscsi driver, and it can be
> > renamed as such, but in the short term we're not ready to choose.
> 
> I disagree.  We have been concentrating on this driver for a long time,
> everyone whoe thinks his driver should have been _the_ software initiator
> should have complained for a long time.

Well ... humour me.  If there's no other stack suitable for submission
within three months, this one can become iscsi and all later comers will
have to modify it to add their features.

James


