From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics
Date: Sun, 30 Nov 2014 10:56:06 -0500
Message-ID: <CAAzz28jYOB+Wd103dLxAV5XCPkXo5ByGyu34d9HZw22y6JZvog@mail.gmail.com>
References: <DDB9C85B850785449757F9914A034FCB3BEF30F3@G9W0766.americas.hpqcorp.net>
	<DDB9C85B850785449757F9914A034FCB3BF02B1C@G9W0748.americas.hpqcorp.net>
	<CAAzz28iEhCgpCMXVkVR0j-CFsT4_T3KvY6uF+MLEZC6wCvmdtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:34579 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaK3P4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2014 10:56:08 -0500
Received: by mail-la0-f42.google.com with SMTP id s18so7651234lam.29
        for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2014 07:56:06 -0800 (PST)
In-Reply-To: <CAAzz28iEhCgpCMXVkVR0j-CFsT4_T3KvY6uF+MLEZC6wCvmdtQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "loberman@redhat.com" <loberman@redhat.com>

Hello Shane,

So far so good on the upstream, built as a new driver.
I need to run some more tests to capture stats and validate the
numbers, so far just functional tests and reading sysfs numbers.
I then need to backport to RHEL6 and RHEL7 kernels as we have two BZ's
out there for this.
WIll be working on that this coming week.
I needed to get some "real" tape hardware ready, so took a while to
get that staged, started out using mhvtl and that seemed fine.

Thanks
Laurence

On Thu, Nov 20, 2014 at 7:09 PM, Laurence Oberman <oberman.l@gmail.com> wrote:
> Hi Shane,
> I was actually about to pull this patch and test it.
> Lots of changes and a big patch so going to create a another driver as
> a tape stats driver for now for testing.
> Will exercise this fully and provide feedback to the list.
> Regards
> Laurence Oberman
>
>
> On Thu, Nov 20, 2014 at 6:49 PM, Seymour, Shane M <shane.seymour@hp.com> wrote:
>> I was wondering if anyone had a chance to review the patch? Comments are appreciated and I'm more than happy to make changes that will allow it to be accepted.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
