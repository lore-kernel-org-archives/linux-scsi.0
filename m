From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 11/15] target: WRITE_SAME_16 and WRITE_SAME_32 should
 be DATA_SG_IO cdbs
Date: Tue, 28 Jun 2011 13:40:18 -0700
Message-ID: <4E0A3C32.6040604@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com> <1309289377-8029-12-git-send-email-agrover@redhat.com> <20110628201402.GC9676@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1F1UkZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:40:25 -0400
In-Reply-To: <20110628201402.GC9676@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/28/2011 01:14 PM, Christoph Hellwig wrote:
> On Tue, Jun 28, 2011 at 12:29:33PM -0700, Andy Grover wrote:
>> The definition of what's a data and what's a control CDB is not
>> totally clear, but both of these set t_task_lba, so I'm inclined
>> to call them data CDBs.
> 
> Currently DATA cdbs are those that get passes through to the
> backend (except for pscsi which gets all of them). As the backends
> can't handle WRITE_SAME this patch is incorrect.

Ah yes that makes sense, I'll delete this patch.

> I have a nice prototype to kill that whole DATA vs CONTROL flag thing,
> which will be much nicer after your series.  Once the guts of your
> patches hit the tree I'll resubmit them.

Sounds really good. I was pondering if that was possible.

Thanks -- Regards -- Andy
