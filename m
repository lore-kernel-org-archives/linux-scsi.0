From: Jens Axboe <axboe@kernel.dk>
Subject: =?UTF-8?B?UmU6IGRyaXZlcnMvYmxvY2svY3BxYXJyYXkuYzo5Mzg6MjogZXJyb3I=?=
 =?UTF-8?B?OiB0b28gbWFueSBhcmd1bWVudHMgdG8gZnVuY3Rpb24g5oW0bGtfcnFfbWFwX3M=?=
 =?UTF-8?B?Z++/vQ==?=
Date: Thu, 14 Jun 2012 11:05:33 +0200
Message-ID: <4FD9A95D.40903@kernel.dk>
References: <4fd91c3f.KAwMcygw9fFGn9Cx%wfg@linux.intel.com> <4FD984F3.3070502@kernel.dk> <20120614090151.GA12013@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2FNJFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2012 05:05:40 -0400
In-Reply-To: <20120614090151.GA12013@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fengguang Wu <wfg@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, virtualization@lists.linux-foundation.org

On 06/14/2012 11:01 AM, Fengguang Wu wrote:
> Hi Jens,
> 
> On Thu, Jun 14, 2012 at 08:30:11AM +0200, Jens Axboe wrote:
>> On 06/14/2012 01:03 AM, wfg@linux.intel.com wrote:
>>> FYI, kernel build failed on
>>>
>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git multiqueue
>>> head:   e9a6aa8a0b7b93195774a9fcf551632bf3abcd97
>>> commit: 67db7275fa4325d46853a4bfcb79acf32e48eca8 [1/3] multiqueue: a hodge podge of things
>>
>> The multiqueue branch is a private branch, it's known broken on many
>> configs at the moment.
> 
> OK. Sorry my script just blindly build tests every new/updated branches
> in the tree. It does try to reduce noise level by remembering all warned
> error messages. However if it still presents a problem to the private
> branches, I can either explicitly blacklist "multiqueue", or let the
> script automatically skip commits whose "^Signed-off-by:" is still missing.

It's not a problem that you're building various branches, as long as you
are expecting a bit of noise :-). In fact I applaud your effort on
expanding the scope of building others branches.

But it does raise the question of how do we best signal intermediate
branches like this, so they can be avoided until they are ready. The
blacklist doesn't seem like a great choice, since then I have to
remember to remind you when it _is_ ok to build it.

How about some arbitrary tag? Instead of checking a Signed-off-by, I
could just add a Dont-Auto-Build or something like that. What do you
think?

-- 
Jens Axboe

