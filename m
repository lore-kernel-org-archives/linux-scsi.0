From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Removing the qlogicfc driver
Date: Sun, 01 Feb 2004 17:52:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401D2ED7.2060807@free.fr>
References: <B179AE41C1147041AA1121F44614F0B0598E46@AVEXCH02.qlogic.org> <1074606124.400d302cac80e@imp2-l.free.fr> <20040201160934.A15908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.wanadoo.fr ([193.252.22.26]:1365 "EHLO
	mwinf0502.wanadoo.fr") by vger.kernel.org with ESMTP
	id S265365AbUBAQwm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 11:52:42 -0500
In-Reply-To: <20040201160934.A15908@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Jan 20, 2004 at 02:42:04PM +0100, christophe.varoqui@free.fr wrote:
> 
>>>Please let me know how it works out for you.  I'd like to forward
>>>it along for inclusion once I get a bit more internal runtime in my
>>>rings.
>>>
>>
>>I report it works flawlessly with "2.6.0-udm5 (== mm2) + qla8b8 + patch".
> 
> 
> This means there are no other objections and we can remove driver?
> 
If the SNS patch from A. Vasquez gets in, yes, no objections.

Thanks for caring,
cvaroqui
