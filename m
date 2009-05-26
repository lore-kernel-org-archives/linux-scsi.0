From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 00:03:11 +0200
Message-ID: <ac3eb2510905261503k32db6197m84d1e78858e53da1@mail.gmail.com>
References: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com>
	<Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61743 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZEZWDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 18:03:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Tue, May 26, 2009 at 23:56, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 26 May 2009, Kay Sievers wrote:
>
>> Ok, I copied my newly installed system to another disks, to have a
>> root filesytem to trash again by this bug. :)
>>
>> Which of your patches should I try?
>
> James's patch, not mine.

I tried both, both don't fix the issue. With Alan's patch it *seems*
the target device never gets removed, at least I didn't see anything
in the kobject debug logs.

Kay
