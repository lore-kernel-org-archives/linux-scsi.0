From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: 20 Aug 2004 23:39:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093059553.2688.679.camel@mulgrave>
References: <1093053368.3318.569.camel@mulgrave>
	<4126BFCC.2000702@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:32216 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268838AbUHUDjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 23:39:15 -0400
In-Reply-To: <4126BFCC.2000702@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-08-20 at 23:21, Jeff Garzik wrote:
> Do you forsee ever adding more feature bits like this?

Never say never, but the standard looks now to be fixed.  The only
waiting extension of SPI5 was fast-360, which doesn't look like being
realised.

> It seems to me that a more maintainable approach is to cache relevant 
> INQUIRY data in a buffer, and then create accessor macros for 
> programmers' use.
> 
> That way you don't have to keep adding members (really, mnemonics) to a 
> data structure, and associated initialization code, each time the 
> mid-layer or some low-level drivers want to test a new feature bit. 
> Initialization via memcpy is easy and automatic.

Only if someone else converts all the drivers...but yet, if more bits
come along, that's probably what we should do.

James


