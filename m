From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Sun, 04 May 2008 15:48:52 +0400
Message-ID: <481DA2A4.10607@vlnb.net>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:54240 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093AbYEDLsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 07:48:25 -0400
In-Reply-To: <20080502155525.GA16353@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Christoph Hellwig wrote:
> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>> Regarding scsi_execute_async(): I didn't know that this API is on its
>> way out. What will it be replaced by, and when ?
> 
> blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
> ontop to build requests.

scsi_execute_async() is already a nice and simple helper function on top 
blk_execute_rq_nowait(). What's the point then to remove it? Do you 
consider that exposing scsi_execute_async() internals to its users is 
better?

>> Bart.
> ---end quoted text---
> 

