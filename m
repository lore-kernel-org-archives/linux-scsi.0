From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Fri, 12 Dec 2008 08:21:08 +0100
Message-ID: <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:9414 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYLLHVK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 02:21:10 -0500
In-Reply-To: <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>

On Thu, Dec 11, 2008 at 8:58 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> On Thu, 2008-12-11 at 20:24 +0100, Bart Van Assche wrote:
>> On Thu, Dec 11, 2008 at 4:14 AM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > Things are moving quickly for Target_Core_Mod/ConfigFS and LIO-Target
>> > v3.0 development, and I invite folks to have a look at the code.  To
>> > dive into the rest of the v3.0 code via git-web, check out:
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core
>>
>> I didn't have a look at the LIO code, but I ran it through checkpatch.
>> The result summary is as follows:
>>
> Thanks for the note, but checkpatch output on the entire tree (not just
> the patchs I posted) does not really help the discussion.  Obviously
> this is on my list before submission for Target_Core_Mod/ConfigFS for
> v2.6.29.  However, what would be nice if you actually sent a kernel
> patch for these issues.

I ran checkpatch on the files in drivers/lio-core ONLY. I did this by
converting all the files in drivers/lio-core through a script into a
patch, and by running checkpatch on the generated patch.

And as you already know I'm not going to work on LIO.

Bart.
