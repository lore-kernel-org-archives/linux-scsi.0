From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 09:09:28 -0500
Message-ID: <1147874968.3463.5.camel@mulgrave.il.steeleye.com>
References: <20060517002542.81288.qmail@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:36302 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932563AbWEQOKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 10:10:43 -0400
In-Reply-To: <20060517002542.81288.qmail@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-05-16 at 17:25 -0700, Luben Tuikov wrote:
> Erm, no, actually, I'm not talking about a SAM nexus.  I'm talking
> about
> the nexus established between SCSI Core and LLDD when SCSI Core called
> queuecommand().  This nexus exists until the LLDD calls done().

So you want the mid layer to have a different view of the nexus from
SAM?  I really think we should be following SAM unless there's a very
good reason not to.

So, in this case, what's the reason the mid-layer should preserve a
nexus SAM says (and the LLD knows) has been terminated?

James


