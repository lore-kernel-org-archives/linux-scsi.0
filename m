From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Tue, 14 Mar 2006 02:13:08 -0500
Message-ID: <44166D04.3070100@garzik.org>
References: <NONAMEBgJJ72jYxDwLd000000d3@nonameb.ptu.promise.com> <20060313192042.56bf67b3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:36516 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750887AbWCNHNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 02:13:11 -0500
In-Reply-To: <20060313192042.56bf67b3.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Ed Lin <ed.lin@promise.com>, linux-scsi@vger.kernel.org, promise_linux@promise.com, linux-kernel@vger.kernel.org

Andrew Morton wrote:
> "Ed Lin" <ed.lin@promise.com> wrote:
>>I guess DMA_32BIT_MASK is OK?
> 
> 
> If that's semantically what the 0xffffffff means then yes.


It means "select lower 32 bits, because the other 32 bits are 
elsewhere."  Since its an arg to cpu_to_le32() I suppose there is an 
implicit truncation in there, but I add such masking myself to my own 
code.  Makes it more clear to the reader what's going on, IMO.

Its not quite what DMA_32BIT_MASK intends, either, IMO.

	Jeff


