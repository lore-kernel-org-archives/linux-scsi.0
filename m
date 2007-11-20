From: David Miller <davem@davemloft.net>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 16:57:08 -0800 (PST)
Message-ID: <20071119.165708.37213607.davem@davemloft.net>
References: <1195518864.6970.23.camel@pasglop>
	<20071119.164611.64664648.davem@davemloft.net>
	<1195520101.6970.28.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54711
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXKTA5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 19:57:09 -0500
In-Reply-To: <1195520101.6970.28.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 20 Nov 2007 11:55:01 +1100

> BTW. What is the status nowadays with skb's ?

Good question.

Some drivers are problematic (or were) because they put
DMA descriptor chaining information at the head of the
buffer, but those have been fixed either to use alternate
descriptor ring facilities or make the proper DMA sync
calls.
