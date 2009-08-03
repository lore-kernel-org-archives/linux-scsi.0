From: "John Stoffel" <john@stoffel.org>
Subject: Re: SCSI git trees
Date: Mon, 3 Aug 2009 15:13:15 -0400
Message-ID: <19063.14027.208148.82667@stoffel.org>
References: <1248887256.3900.78.camel@mulgrave.site>
	<19063.9181.620137.814464@stoffel.org>
	<1249325826.3943.207.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:58717 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZHCTNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 15:13:22 -0400
In-Reply-To: <1249325826.3943.207.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: John Stoffel <john@stoffel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> On Mon, 2009-08-03 at 13:52 -0400, John Stoffel wrote:
>> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> 
James> It seems I got unsubscribed from linux-scsi last week while I was on
James> holiday and I've likely missed a slew of patches, it seems like an
James> appropriate time to remind everyone how the SCSI trees work.
>> 
James> ---
>> 
James> There are two git based scsi trees:
>> 
James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git
>> 
James> called the scsi-misc tree for patches being collected for the
James> next merge window.  And
>> 
>> I don't see my patch to block/Kconfig to make BLK_DEV_BSG be enabled
>> by default.  Is this going to be pushed for 2.6.32-rc1 when the merge
>> window opens up?  
>> 
>> I've attached the patch, just to make sure.  Let me know if I should
>> send it in properly.
>> 
>> Thanks!
>> John
>> 
>> 
>> Make Block Layer SG support v4 the default, since recent udev versions
>> depend on this to access serial numbers and other low level info
>> properly.
>> 
>> This should be backported to older kernels as well, since most distros
>> have
>> enabled this for a long time.
>> 
>> Signed-off-by: John Stoffel <john@stoffel.org>
>> ---
>> block/Kconfig |   11 +++++++----
>> 1 files changed, 7 insertions(+), 4 deletions(-)
>> 
>> diff --git a/block/Kconfig b/block/Kconfig
>> index e7d1278..55bbefc 100644
>> --- a/block/Kconfig
>> +++ b/block/Kconfig

James> Actually, this one isn't really SCSI; it's block (Jens cc'd).

Thanks for the cc to Jens.  I'd argue that it is SCSI, since it's
about enbabling the Generic SCSI v4 stuff.  But hey, I'd be happy to
see this enabled by default no matter how it goes into the kernel.

James> It's Jens call on the backport, but my feeling is that removing
James> a feature from experimental is really an enhancement not a bug
James> fix, so it's not really eligible under the backport rules.

Sure, I can understand this, but since the feature has been around for
quite a while, and since most (as I understand it, but haven't
confirmed) distros enable it by default, I think the risk is low.

But again, it's not clear to me whether you think A) this should go
into 2.6.32 and B) whether it will go through your tree or if I should
try to push it through Jens.

I await the discussion.  It's really a trivial change, and its makes a
huge difference to people using Udev to manage devices properly.

Thanks,
John



