From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
Date: Fri, 18 Mar 2011 18:15:47 -0700
Message-ID: <4D8403C3.6020300@intel.com>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6> <20110318225016.GB15921@suse.de> <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com> <20110319002246.GB14249@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490Ab1CSBPu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 21:15:50 -0400
In-Reply-To: <20110319002246.GB14249@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>

On 3/18/2011 5:22 PM, Greg KH wrote:
> On Fri, Mar 18, 2011 at 04:10:10PM -0700, Dan Williams wrote:
>>> I needed all patches in linux-next _before_ the merge window opened to
>>> be able to accept it.
>>
>> Yes, I know, and as dmaengine maintainer I also hate being ambushed by
>> last minute patches, but now I am unfortunately one of those annoying
>> people on the other side of the coin.
>
> Then you should know better than to try to go around the well-known
> rules :)

Yes...

/me about to push his luck

...I also know the rules can sometimes be bent:

$ git describe --contains 9d200153
v2.6.35-rc2~14^2~15

commit 9d20015391dfc47f6371492925cc0333ac403414
Author: Stepan Moskovchenko <stepanm@codeaurora.org>
Date:   Wed May 19 11:03:30 2010 -0700

     Staging: add MSM framebuffer driver

I see you got flamed for that:
"I pulled, but quite frankly, I don't want to see this kind of pull 
request again. There's just no _point_.

I'll take new drivers outside the merge window, but there has to be some
_reason_ for them. See the whole SCSI discussion a few merge windows 
ago. The new driver needs to improve the life of somebody to the point 
where I want to feel that there is a _reason_ for pulling it outside the 
merge window.

These drivers? Not so much. Not even f*cking close.

In other words: tell me why the new drivers couldn't just have waited 
for the next merge window? Really?"

As Jeff pointed out:
"It seemed like this was turning into another driver that would get held 
outside the kernel until it's "perfect."  If that is the case, Linus has 
also made it clear we should get drivers for high volume, shipping 
hardware into the kernel, even if its staging, if the alternative is to 
deny users the driver."

So yes, we are targeting that exception.  I'm up for taking the heat 
directly if you want...  because the pull request will need to backed up 
with justification.

--
Dan
