From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [ATTEND]
Date: Tue, 7 Feb 2012 18:31:18 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B915D0A6CB@nsmail.netscout.com>
References: <CAH+dOxKMwMskM18=GhBmEao4aSvZmccSiZmmnZm42TBMPUFONw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <CAH+dOxKMwMskM18=GhBmEao4aSvZmccSiZmmnZm42TBMPUFONw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, dedekind@infradead.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kent Overstreet
> Sent: February 02, 2012 4:04 AM
> To: lsf-pc@lists.linux-foundation.org
> Cc: linux-scsi@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Subject: [ATTEND]
> 
> I'm the author of bcache - a flash caching implementation for block
> devices. I'd like to talk a bit about it and some
> cleanups/improvements to the block layer.

Kent,

I came across UBIFS when I was looking to implement just a backing
device. So I'm trying to understand if you looked at UBIFS and if parts
of that could have been used(or if they are used already?). Because in
the end we need to create an erase-aware FS(without the usual
defrag/syscall/etc support) and manage that in conjunction with
block-layer. Agreed that UBIFS is a generic FS. But we also need to
worry about erase-cycles/counters etc
(http://lxr.linux.no/#linux+v3.2.5/Documentation/filesystems/ubifs.txt#L
12 - all the 5 points). Plus, it supports on-the-fly compression. I've
never used UBIFS. So I don't know how it performs. May be we could just
pick UBI's FS part and stick that with your block-layer code?

CC'd Artem (found his email from sys-abi file).


Chetan Loke
