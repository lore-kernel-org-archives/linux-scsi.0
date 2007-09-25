From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Mon, 24 Sep 2007 20:25:28 -0400
Message-ID: <46F85578.70503@garzik.org>
References: <20070721203410.GA1004@havoc.gtf.org> <1189865576.3339.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41511 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbXIYAZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2007 20:25:32 -0400
In-Reply-To: <1189865576.3339.0.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

James Bottomley wrote:
> On Sat, 2007-07-21 at 16:34 -0400, Jeff Garzik wrote:
>> This is the rest of the stuff checked into the 'gdth' branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
>>
>> As noted before, I'm fine with Christoph's gdth work superceding mine,
>> or whatever.  This was just me poking around.  Hopefully the patches
>> are useful for illustration, if nothing else.
>>
>> 1) [SCSI] gdth: kill gdth_{read,write}[bwl] wrappers
>> 2) [SCSI] gdth: Move probe-time error handling code to end of each function
>> 3) [SCSI] gdth: make some virt ctrlr code common; shuffle SHT members
>> 4) [SCSI] gdth: convert to modern SCSI host alloc/scan
> 
> OK, we've had these competing patch sets floating around for two months
> now.  Christoph and Jeff, can we get agreement on which is going in?

Well, my opinion is

1) When judging by total amount of positive improvement, Christoph's 
patches are superior -- he has more overall cleanups than I do.

2) When judging by likelihood of inducing breakage, I feel my changes 
are superior.  My gdth changes tightly adhere to the 
equivalent-transformation method of shuffing code around, enabling 
further improvements.  IOW, I resisted the urge to make cleanups and fix 
insignificant, pre-existing bugs during the transformations.

3) I am utterly unmotivated to merge the two patchsets.  Someone should 
make an executive decision, pull one patchset, and drop the other.  My 
coding "mood" has swung from cleaning up code to writing new SAS drivers :)

	Jeff


