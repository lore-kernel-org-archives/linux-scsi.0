From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [ATTEND]
Date: Wed, 8 Feb 2012 12:46:20 -0800
Message-ID: <CAH+dOxLioWLbGy94KKBiXVncokye+bBeyRvM13sCZOf9ATehhQ@mail.gmail.com>
References: <CAH+dOxKMwMskM18=GhBmEao4aSvZmccSiZmmnZm42TBMPUFONw@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B915D0A6CB@nsmail.netscout.com>
	<CAH+dOx+4mL0uMBAjv+zo+XGJvaZvushYT5=Ev=8K8-zVhLHR2w@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B915D0ACF0@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2BHUqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 15:46:21 -0500
Received: by iacb35 with SMTP id b35so1396008iac.19
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2012 12:46:20 -0800 (PST)
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915D0ACF0@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, dedekind@infradead.org

On Wed, Feb 8, 2012 at 10:15 AM, Loke, Chetan <Chetan.Loke@netscout.com> wrote:
> Exactly. So what I'm saying is, if UBI also does ftl then you could be
> duplicating code/efforts. UBI is already upstream. Now whether it
> supports everything we want is another thing.
> (and that's why I CC'd its author). So pieces that aren't there could be
> implemented. But they also talk about erase-counters etc and I don't
> know if I saw something similar in your bucket_struct[or foo_struct].
> May be its somewhere else.

I don't think code sharing is realistic for that stuff, as wear
levelling and all the other flash specific stuff needs to be done in
the same place if you want to avoid having multiple stacked indexes,
and adding wear levelling and a copying garbage collector to bcache is
going to be pretty trivial at this point.

But comparing notes/sharing algorithms could definitely be worthwhile.
