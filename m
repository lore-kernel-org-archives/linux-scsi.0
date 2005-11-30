From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/8] iscsi: add rdma attr
Date: Wed, 30 Nov 2005 13:53:53 -0600
Message-ID: <438E0351.9000400@cs.wisc.edu>
References: <1133327562.28356.37.camel@max> <20051130160858.GA15056@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36285 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751573AbVK3TyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:54:03 -0500
In-Reply-To: <20051130160858.GA15056@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Christoph Hellwig wrote:
> On Tue, Nov 29, 2005 at 11:12:42PM -0600, Mike Christie wrote:
> 
>>>From Erez Zilber:
>>
>>Add AF and RDMA provider properties.
> 
> 
> NACK, they're totally useless with the current kernel.
> 

This patchset works without those two patches. Kinda suspected you and 
Dimitry and Alex would not agree on those patches, so already tested 
without them :) Open-iscsi will need to just fixup userspace to account 
for this which has been brought up before so no biggie. Do you guys want 
me to make up a new patchset or will you just pick up the patchset 
without this patch and "[PATCH 4/8] iscsi: add rdma extensions"? Not 
merging those patches, makes this a all bug fix patchset so maybe it is 
2.6.15 worthy.
