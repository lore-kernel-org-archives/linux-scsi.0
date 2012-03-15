From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Thu, 15 Mar 2012 13:02:48 -0400
Message-ID: <20120315170248.GB8638@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
 <CAH+dOx+Vgv12w=Q=8hCQggLg+kq6TnT2i3ZtnpZ=bNVyMgk31Q@mail.gmail.com>
 <CAAsGZS5UTrYTbncAjk1Vor6R_-KWDboTw3sh+jXCbXm5q_o-TA@mail.gmail.com>
 <20120314185455.GD28042@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fa0-f46.google.com ([209.85.161.46]:42924 "EHLO
	mail-fa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031939Ab2CORC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 13:02:59 -0400
Received: by faas1 with SMTP id s1so623240faa.19
        for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 10:02:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120314185455.GD28042@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, chetan loke <loke.chetan@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 02:54:56PM -0400, Ted Ts'o wrote:
> On Wed, Mar 14, 2012 at 02:33:25PM -0400, chetan loke wrote:
> > But you are not explaining why dm is not the right stack. Just because
> > it crashed when you tried doesn't mean it's not the right place.
> > flash-cache works, doesn't it? flash-cache's limitation is because
> > it's a dm-target or because it is using hashing or something else?
> > There are start-ups who are doing quite great with SSD-cache+dm. So
> > please stop kidding yourself.
> 
> SATA-attached flash is not the only kind of flash out there you know.
> There is also PCIe-attached flash which is a wee bit faster (where wee
> is defined as multiple orders of magnitude --- SATA-attached SSD's
> typically have thousands of IOPS; Fusion I/O is shipping product today
> with hundreds of thousands of IOPS, and has demonstrated a billion
> IOPS early this year).  And Fusion I/O isn't the only company shipping
> PCIe-attached flash products.
> 
> Startups may be doing great on SSD's; you may want to accept the fact
> that there is stuff which is way, way, way better out there than
> SSD's which are available on the market *today*.
> 
> And it's not like bache which is a new project.  It's working code,
> just like flash cache is today.  So it's not like it needs to justify
> its existence.
> 
> Best regards,
> 
> 					- Ted

Thanks Ted, as usual you word things rather less abrasively than me :)
