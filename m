From: Martin Peschke <mp3@de.ibm.com>
Subject: Re: [Patch] SCSI statistics
Date: Tue, 19 Sep 2006 18:48:30 +0200
Message-ID: <45101F5E.2070909@de.ibm.com>
References: <1158578439.3060.50.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <1158614913.3182.78.camel@laptopd505.fenrus.org> <20060918213424.GS2585@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:48357 "EHLO
	mtagate2.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1030253AbWISQsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 12:48:42 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k8JGmfdT166010
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 16:48:41 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8JGoshc1900550
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 17:50:54 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8JGmeJh002937
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 17:48:40 +0100
In-Reply-To: <20060918213424.GS2585@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Sep 18, 2006 at 11:28:32PM +0200, Arjan van de Ven wrote:
>> wouldn't this be nicer as a block level functionality?
> 
> We already have block layer statistics.

you mean disk_stats_read() etc. in genhd?

> What we don't have are stats
> that measure the other ways to send commands to scsi devices like SG and
> retries that the scsi system does without notifying the block layer.  I
> think both are useful (although at first glance they seem redundant).

There are no statistics that allow to retrieve data similar to my patch,
with the exception of blktrace. But I think blktrace is difficult to use
as sole performance analysis tool on a customer's system with high load
and applications competing with blktrace postprocessing tools.

