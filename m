From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Wed, 14 Mar 2012 14:17:48 -0400
Message-ID: <CAH+dOx+Vgv12w=Q=8hCQggLg+kq6TnT2i3ZtnpZ=bNVyMgk31Q@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
	<CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760284Ab2CNSRt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 14:17:49 -0400
Received: by iagz16 with SMTP id z16so2645906iag.19
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 11:17:48 -0700 (PDT)
In-Reply-To: <CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 2:12 PM, chetan loke <loke.chetan@gmail.com> wrote:
> I'm not a dm guru but a quick scan at flash-cache seems like it does
> what you are saying. Now, if performance isn't acceptable then hashes
> can be replaced with trees and what-not. Also no one would need to
> re-invent the stacking mechanism. I saw thin support(atleast
> documented) for dm. Plus, no matter what cache you come up with you
> may have to persist/store the meta-data associated with it. And dm
> seems like the right place to abstract that.

Bcache kills flash cache on performance - bcache can do around a
million iops on 4k random reads, and beats it on real world
applications and hardware too (i.e. mysql).

I'm not aware of any real features I'm missing out on by not using dm...
