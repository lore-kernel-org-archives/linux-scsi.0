From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Mon, 26 Jan 2015 10:58:36 +0100
Message-ID: <54C60FCC.4060601@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
 <20150123131249.GA8045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:22782
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754484AbbAZJ6o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2015 04:58:44 -0500
In-Reply-To: <20150123131249.GA8045@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/23/15 14:12, Christoph Hellwig wrote:
> On Fri, Jan 23, 2015 at 01:05:30PM +0100, Bart Van Assche wrote:
>> There is some confusion in the SCSI core and in SCSI LLDs around the
>> meaning of sc_data_direction and whether or not this member can have the
>> value DMA_BIDIRECTIONAL. Clear up this confusion. The patches in this
>> series are:
> 
> I wonder if we should change the code to set DMA_BIDIRECTIONAL for
> bidi commands.  That seems a lot more logical than the current
> version.
> 
> Also I don't think all the debug checks for bidi commands that you
> change should stay at all - driver need to set the QUEUE_FLAG_BIDI to
> ever see a bidi command.
> 
> It would also nice to add a host template flag for bidi support instead
> of having to poke into the block layer request_queue while we're at it.

Hello Christoph,

This makes sense to me. I will rework this patch series as you proposed.

Bart.
