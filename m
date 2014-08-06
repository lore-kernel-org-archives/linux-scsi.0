From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bnx2fc: Set no_async_abort to 1 in SCSI host template.
Date: Wed, 6 Aug 2014 21:17:15 +0200
Message-ID: <20140806191715.GB2642@lst.de>
References: <1407267953-26618-1-git-send-email-chad.dupuis@qlogic.com> <CAHdzE-8o94d4d-tJ2j3iUbR7oCO9QYioAqbtRLbGKonR5UK9ZQ@mail.gmail.com> <alpine.OSX.2.00.1408051656410.2178@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33679 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbaHFTRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 15:17:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1408051656410.2178@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>, linux-scsi@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com

On Tue, Aug 05, 2014 at 05:02:46PM -0400, Chad Dupuis wrote:
>
>
> On Tue, 5 Aug 2014, Venkatesh Srinivas wrote:
>
>> On Tue, Aug 5, 2014 at 12:45 PM, Chad Dupuis <chad.dupuis@qlogic.com> wrote:
>>> Set this to 1 for now as we've observed crashes when this is set to the default
>>> value of 0.
>>
>> What sorts of crashes have you seen with no_async_abort=0 (default)?
>> At which kernel versions?
>
> We've seen a crash where we use a request that has already been used else 
> where when requeuing a SCSI command:

What kernel version is this one?  The last issues we saw in this area
were before we pulled fixes for these scenarios in:

d555a2abf3481f81303d835046a5ec2c4fb3ca8e
644373a4219add42123df69c8b7ce6a918475ccd
7daf480483e60898f30e0a2a84fecada7a7cfac0
c69e6f812bab0d5442b40e2f1bfbca48d40bc50b
8922a908908ff947f1f211e07e2e97f1169ad3cb
a33c070bced8b283e22e8dbae35177a033b810bf

