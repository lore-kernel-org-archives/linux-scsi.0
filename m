From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 06 Jun 2003 19:21:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE121F8.2050807@rogers.com>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org> <3EE0B316.4060207@rogers.com> <20030606214920.A3240@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-mail.bloor.is.net.cable.rogers.com ([66.185.86.72]:19937
	"EHLO fep02-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262356AbTFFXHy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 19:07:54 -0400
In-Reply-To: <20030606214920.A3240@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

Christoph Hellwig wrote:
> On Fri, Jun 06, 2003 at 11:28:22AM -0400, Luben Tuikov wrote:
> 
>>James was talking about ``device server not ready'' aliased to
>>online -- i.e. if online is 0 then only INQUIRY or TUR should
>>be sent from SCSI Core (unless SCSI Core decides to _know_ about
>>the different ULP).  The semantics on this are somewhat touched
>>in the INQUIRY description in SPC-3.
> 
> 
> Okay, I thought about device physically no more present on the
> bus for !online.
> 
> 
>>(This means that the device is on the SAN, but not ready to
>>process commands.)
>>
>>You're talking about hardware removal -- more specifically
>>logical removal of a host
> 
> 
> host or device.  Think about sbp2/ieee1394 or FC.

Did you mean to write something more?

-- 
Luben



