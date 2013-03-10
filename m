From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: [LSF/MM TOPIC] Making sure soft SCSI Targets are Valid
Date: Sun, 10 Mar 2013 16:27:20 -0700
Message-ID: <CAN05THS92Rw-nFA49UoohcY6ZFfngAH6sDgcq7tdeiVTb3JZfA@mail.gmail.com>
References: <51081F68.1030808@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:54043 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3CJX1W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Mar 2013 19:27:22 -0400
Received: by mail-we0-f179.google.com with SMTP id p43so2847282wea.38
        for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2013 16:27:20 -0700 (PDT)
In-Reply-To: <51081F68.1030808@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

Hi All

I would like to attend LSF/MM and talk with people about scsi and iscsi testing.

I am the author/maintainer for libiscsi which is userspace initiator
used primarily by KVM/QEMU.
This package also includes a pretty big test suite for mainly SCSI but
also a lot of interesting iSCSI tests.

As someone hacking on a testsuite, I would like to meet with initiator
and target implementors and talk
about the existing test suites, and how we can work together from here.


What can i bring to FSF/MM?
========================
I like SCSI and I like writing tests.
I have a big existing testsuite that I think at least some of you can
benefit from.
I would like to talk to people on how to make the test suite even better.
Can we work out a platform where we can build even better and more
comprehensive test suites ?
etc.


regards
ronnie sahlberg

On Tue, Jan 29, 2013 at 11:13 AM, Lee Duncan <lduncan@suse.com> wrote:
> Hi:
>
> I'm not sure if there is much interest in this, but I've recently
> realized that there is no good free software to validate iSCSI targets,
> not to mention FCOE targets, IB soft targets, etc. There's just no way
> to know if any change you make is "legal" short of learning to speak
> SCSI geek spec (or waiting to see what fails when you make a subtle change).
>
> So I have been working with the (user-space) libiscsi creator and
> maintainer, Ronnie Sahlberg, to enhance his test suite. But this only
> addresses iSCSI targets. Some of his tests have already shown problems
> like kernel panics when an incorrect bit is injected, showing the need
> for such testing.
>
> It occurs to me it would be most valuable if we had more generic SCSI
> tests, not even limited to soft targets, available to developers and
> manufacturers. How best to support such tests with our SCSI layer, and
> what tests are needed now and in the future may be a good topic for
> discussion.
> --
> Lee Duncan
> SUSE Labs
