From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
Date: Tue, 13 Nov 2007 21:07:26 -0800 (PST)
Message-ID: <20071113.210726.39231381.davem@davemloft.net>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<1194968001.3416.12.camel@localhost.localdomain>
	<33307c790711130946j3ae10dcx9d776bc9671710f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40382
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbXKNFH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 00:07:26 -0500
In-Reply-To: <33307c790711130946j3ae10dcx9d776bc9671710f7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mbligh@google.com
Cc: James.Bottomley@hansenpartnership.com, akpm@linux-foundation.org, protasnb@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: "Martin Bligh" <mbligh@google.com>
Date: Tue, 13 Nov 2007 09:46:08 -0800

> This is a technical issue with vger.kernel.org mailing lists that I've tried
> addressing before - maybe davem can help fix it?

I think the problem is that certain mail headers show up multiple
times and this makes it look like a looping email so we toss it.

I suspect the one you really need to block out is X-MailingList
or similar.

Why don't you do a few tries and I'll try to remember to keep an
eye out for the bounces?

Thanks.
