From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
Date: Thu, 21 Feb 2008 09:41:13 -0600
Message-ID: <1203608474.3208.10.camel@localhost.localdomain>
References: <47BD9588.9080803@compro.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59714 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082AbYBUPlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 10:41:20 -0500
In-Reply-To: <47BD9588.9080803@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 10:15 -0500, Mark Hounschell wrote:
> I seem to have run into some sort of regression in the SG_IO interface of 2.6.24.2. 
> I have an application that up until 2.6.24 worked fine. The 2.6.23.16 kernel works fine.
> 
> During reads I get these kernel messages. Writes and other functions _seem_ OK. Actually basic
> reads  are working. Its with large BC reads using an io_vec list that the problem shows up.
> 
> Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
> Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
> Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256

Help me a little here.  What was the io_vec and command you sent in to
produce this?  The aic debugging information implies a single element sg
list for a 256 byte read.

James


