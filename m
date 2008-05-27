From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 27 May 2008 14:42:51 +0800
Message-ID: <a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	 <20080520030232.fc91b64e.akpm@linux-foundation.org>
	 <20080520172139.GA11666@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:5665 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbYE0Gmx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2008 02:42:53 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1619951tic.23
        for <linux-scsi@vger.kernel.org>; Mon, 26 May 2008 23:42:51 -0700 (PDT)
In-Reply-To: <20080520172139.GA11666@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, May 21, 2008 at 1:21 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
>> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>>
>> > Converting class semaphore to mutex cause lockdep warnings due to
>> > class_interface_register/unregister will possible call device_add/del
>>
>> Shouldn't we just fix that?
>
> Um, no, that's a "feature" that some types of hardware and interfaces
> require.
>
> This is one reason I really don't like this type of conversion, it's
> causing lots of problems for no known gain.
>
> So I would just recommend dropping this patch set, the current "convert
> class semaphore to a mutex" patch in the -mm tree is already causing
> lockdep warnings, and trying to do something like this isn't really
> going to solve the root problem here.

At last, I decide to give up.

Andrew, I could not do more for this issue now, you can drop the
conversion patch if there's no suitable fix from others.

Thanks
Dave
