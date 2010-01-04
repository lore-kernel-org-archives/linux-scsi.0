From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH] scsi_lib: Bug in completion of bidi commands
Date: Mon, 04 Jan 2010 09:26:18 +0200
Message-ID: <4B41981A.6080204@panasas.com>
References: <Pine.LNX.4.44L0.1001031149380.29885-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:49054 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752711Ab0ADH0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 02:26:22 -0500
In-Reply-To: <Pine.LNX.4.44L0.1001031149380.29885-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>, Stable Tree <stable@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On 01/03/2010 06:55 PM, Alan Stern wrote:
> On Sun, 3 Jan 2010, Boaz Harrosh wrote:
> 
>>> What patch of mine are you referring to?  So far James has rejected all
>>> the patches I have submitted recently.  I'm going to try again in the 
>>> near future...
>>>
>>
>> OK, that's my answer, I didn't know.
>>
>> Would you want that I attempt that collapsing of scsi_end_request() into scsi_io_completion
>> and the cleanup that implies? (that's the patch I meant.)
> 
> Okay, I don't mind if you would like to rewrite that patch.  The 
> version I wrote didn't just move code from one subroutine to another; 
> it also made a few semantic changes (the retry counter and the "error" 
> argument to blk_end_request()).  You'll probably want to break it 
> up into a few patches, where the first simply moves the code around and 
> the later ones do more significant things.
> 

Hi Alan, thanks

I'll only do the former and I'll let you continue with the later. .I.E the
code rearrangement and cleanup. Then perhaps it would be easier for you to
enhance the code with the retries and error returns. I do not have the setup
that can test / demonstrate those fixes, I'd rather you did them.

> As I recall, the most recent version of that patch is here:
> 
> 	http://marc.info/?l=linux-scsi&m=123991011815404&w=2
> 

Thanks

> Alan Stern
> 

Boaz
