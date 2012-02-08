From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [ATTEND]
Date: Wed, 8 Feb 2012 13:15:51 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B915D0ACF0@nsmail.netscout.com>
References: <CAH+dOxKMwMskM18=GhBmEao4aSvZmccSiZmmnZm42TBMPUFONw@mail.gmail.com><D3F292ADF945FB49B35E96C94C2061B915D0A6CB@nsmail.netscout.com> <CAH+dOx+4mL0uMBAjv+zo+XGJvaZvushYT5=Ev=8K8-zVhLHR2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:56529 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754422Ab2BHSPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 13:15:53 -0500
Content-class: urn:content-classes:message
In-Reply-To: <CAH+dOx+4mL0uMBAjv+zo+XGJvaZvushYT5=Ev=8K8-zVhLHR2w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, dedekind@infradead.org

> -----Original Message-----
> From: Kent Overstreet [mailto:koverstreet@google.com]
> Sent: February 07, 2012 10:46 PM
> To: Loke, Chetan
> Cc: lsf-pc@lists.linux-foundation.org; linux-scsi@vger.kernel.org;
> linux-fsdevel@vger.kernel.org; dedekind@infradead.org
> Subject: Re: [ATTEND]
> 
> On Tue, Feb 7, 2012 at 3:31 PM, Loke, Chetan
<Chetan.Loke@netscout.com>
> wrote:
> > I came across UBIFS when I was looking to implement just a backing
> > device. So I'm trying to understand if you looked at UBIFS and if
parts
> > of that could have been used(or if they are used already?). Because
in
> > the end we need to create an erase-aware FS(without the usual
> > defrag/syscall/etc support) and manage that in conjunction with
> > block-layer. Agreed that UBIFS is a generic FS. But we also need to
> > worry about erase-cycles/counters etc

.......
> 
> I don't quite follow what you're trying to do - you want to turn raw
> flash into a block device, i.e. an ftl?
> 
> Bcache is pretty close to being an ftl, and I think what's left will

Exactly. So what I'm saying is, if UBI also does ftl then you could be
duplicating code/efforts. UBI is already upstream. Now whether it
supports everything we want is another thing.
(and that's why I CC'd its author). So pieces that aren't there could be
implemented. But they also talk about erase-counters etc and I don't
know if I saw something similar in your bucket_struct[or foo_struct].
May be its somewhere else.



