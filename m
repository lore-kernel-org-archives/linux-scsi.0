From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Tue, 05 May 2009 12:28:53 +0900
Message-ID: <49FFB275.7000507@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>	 <49FA0349.3090706@garzik.org>	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>	 <49FEA127.1000905@kernel.org> <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZEEDaW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2009 23:30:22 -0400
In-Reply-To: <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, dm-devel@redhat.com

Hello,

Dan Williams wrote:
> On Mon, May 4, 2009 at 1:02 AM, Tejun Heo <tj@kernel.org> wrote:
>>> Couldn't the "fix" also just be a note to users to disable ignore_hpa
>>> if they notice that there raid arrays are not assembling correctly?
>> I don't know.  If it doesn't work automatically, the solution really
>> isn't worth much.  People generally don't (shouldn't need to) have any
>> idea what HPA is.  It basically boils down to "Linux doesn't support
>> RAID".  :-)
>>
>> Maybe we should just put this issue to the rest and strongly advise
>> people against BIOS raids.
> 
> That's a bit too far :-).  The real issue is that Linux is ignoring a
> property of the platform.  To me ignoring HPA is like ignoring an e820
> reserved memory region.  You might be able to get away with it
> sometimes, but other times it breaks.

Well, somewhat but not quite.  The difference is with backward
compatibility and the fact that HPA has been used for many different
creative ;-) purposes including working around BIOS limitations.

> However, in the end I think having 'alt_size' available is a useful
> mechanism for discovering and handling the ignore_hpa=1 case.   The
> policy about when to trust it can be left to userspace.

Pushing this in the kernel without updating dm-raid is kind of
pointless.  Who should I be poking to get the userland part moving?

Thanks.

-- 
tejun
