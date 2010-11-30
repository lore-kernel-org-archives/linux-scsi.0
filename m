From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Tue, 30 Nov 2010 18:23:57 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local> <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de> <4CF521DE.7020800@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs11.mail.saunalahti.fi ([195.197.172.106]:34996 "EHLO
	vs11.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0K3QYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 11:24:03 -0500
In-Reply-To: <4CF521DE.7020800@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>, linux-scsi@vger.kernel.org

On Tue, 30 Nov 2010, Boaz Harrosh wrote:

> On 11/30/2010 03:31 PM, Lukas Kolbe wrote:
> > On Mon, 2010-11-29 at 19:09 +0200, Kai Makisara wrote:
> > 
....
> It looks like something is broken/old-code in sr. Most important LLDs
> and block-layer scsi-ml fully support sg-chaining that effectively are
> able to deliver limitless (Only limited by HW) sg sizes. It looks like
> sr has some code that tries to allocate contiguous buffers larger than
> PAGE_SIZE. Why does it do that? It should not be necessary any more.
> 
The relevant driver is st and it use sg chaining when necessary. I tried 
to explain that the effective limit in this case comes from mptsas. I 
don't know if it is HW limit or driver limit.

Kai

