From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [ANNOUNCE] QLogic FC Driver for Linux kernel 2.5 available.
Date: 12 May 2003 17:37:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3ptmnsv7d.fsf@trained-monkey.org>
References: <3EBDB953.1040908@wanadoo.es>
	<20030512190013.GA23981@praka.local.home>
	<1052768456.2093.64.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trained-monkey.org ([209.217.122.11]:19723 "EHLO
	trained-monkey.org") by vger.kernel.org with ESMTP id S262718AbTELVY4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 17:24:56 -0400
In-Reply-To: <1052768456.2093.64.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Vasquez <praka@san.rr.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "James" == James Bottomley <James.Bottomley@steeleye.com> writes:

James> On Mon, 2003-05-12 at 14:00, Andrew Vasquez wrote:
>> Unfortunately, no.  QLogic has no plans to update qla1280 -- all
>> parallel SCSI HBAs have been EOLed.

James> Could Qlogic at least publish the documentation for these chips
James> electronically so we have a vague chance of supporting them?

James> At the moment most of the ISP1020 and ISP1040 bug reports
James> elicit sympathy but not much else.

I very strongly support that idea, right now all the changes I have
made to the qla1280 driver have pretty much been done in the dark.

Cheers,
Jes
