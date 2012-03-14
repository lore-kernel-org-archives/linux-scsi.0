From: chetan loke <loke.chetan@gmail.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Wed, 14 Mar 2012 14:12:07 -0400
Message-ID: <CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56490 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030967Ab2CNSMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 14:12:07 -0400
Received: by dadp12 with SMTP id p12so3307204dad.11
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 11:12:07 -0700 (PDT)
In-Reply-To: <20120314155339.GC30235@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 11:53 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 14, 2012 at 09:32:28AM -0400, Kent Overstreet wrote:
>> I'm already registered to attend, but would it be too late in the
>> process to give a talk? I'd like to give a short talk about bcache, what
>> it does and where it's going (more than just caching).
>
> [CCing dm-devel list]
>
> I am curious if you considered writing a device mapper driver for this? If
> yes, why that is not a good choice. It seems to be stacked device and device
> mapper should be good at that. All the configuration through sysfs seems
> little odd to me.

I'm not a dm guru but a quick scan at flash-cache seems like it does
what you are saying. Now, if performance isn't acceptable then hashes
can be replaced with trees and what-not. Also no one would need to
re-invent the stacking mechanism. I saw thin support(atleast
documented) for dm. Plus, no matter what cache you come up with you
may have to persist/store the meta-data associated with it. And dm
seems like the right place to abstract that.



> Vivek

Chetan
