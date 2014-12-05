From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] [SCSI] Blacklist RSOC for Microsoft iSCSI target
 devices
Date: Fri, 05 Dec 2014 10:59:18 -0600
Message-ID: <5481E466.3070802@cs.wisc.edu>
References: <1417659492-2679-1-git-send-email-martin.petersen@oracle.com> <1417659492-2679-2-git-send-email-martin.petersen@oracle.com> <54810957.8080706@cs.wisc.edu> <yq1zjb2g7rh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47869 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaLEQ71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 11:59:27 -0500
In-Reply-To: <yq1zjb2g7rh.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 12/4/14, 8:17 PM, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:
>
> Mike> In case other people test this patch, I wanted to warn people that
> Mike> the MS iSCSI target does the same sequence (sends reject PDU then
> Mike> drops the connection on us) for any command it does not
> Mike> support. We end up seeing the same problem for other commands.
>
> Ick. Have you pinged MS about this again recently? Doesn't sound like
> we'd be the only ones tripping over something like this.

I have not. Until the other day in this thread, I thought they fixed it 
in the newer target versions. I just noticed this behavior was the 
general error handling behavior for all unknown commands yesterday when 
testing your patch. Trying to write up an analysis about why they should 
return a ILLEGAL REQUEST and not drop the connection for unsupported 
commands.
