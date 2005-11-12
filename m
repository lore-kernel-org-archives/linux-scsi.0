From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Sat, 12 Nov 2005 13:12:20 -0600
Message-ID: <43763E94.40406@cs.wisc.edu>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37567 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932466AbVKLTMb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 14:12:31 -0500
In-Reply-To: <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Tue, 8 Nov 2005, Mike Christie wrote:
> 
> 
>>convert st to always send scatterlists and kill scsi_request
>>usage.
>>
>>This is the same as last time as it was posted, but with Kai's patches
>>merged and we now pass the bytes value to scsi_execute_async.
>>
> 
> This does not work "out of the box". The changes in st are almost the same 
> ones than before but the world around st has changed ;-) This has revealed 
> at least one bug in st that is fixed by the patch at the end of this 

ok thanks.

> message. After this patch some simple tests succeed but there seem to be 
> still problems with larger requests. I don't have time to continue 
> debugging just now but I should be able to post more results during this 
> weekend.
>

Was there a oops or lockup or any debug output you can send me? I will 
try some more large request tests with scsi_debug. You also have to 
compile your kernel with SCSI_MAX_PHYS_SEGMENTS == 255 to get larger 
requests now.
