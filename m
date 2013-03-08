From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Fri, 8 Mar 2013 14:36:27 +0200
Message-ID: <CAJZOPZLnVLXqcvmjhxuhDghkuAHdf5RmxNSM2gy8LqgCqvh8HQ@mail.gmail.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	<1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
	<CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:38172 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3CHMg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Mar 2013 07:36:28 -0500
In-Reply-To: <CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Fri, Mar 8, 2013 at 6:14 AM, Roland Dreier <roland@kernel.org> wrote:
> Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > +EXPORT_SYMBOL(iscsit_get_transport);

> It's not clear to me why this needs to be exported.  Who would use it
> outside the core iscsi target module?

Yep, as Nic noted, we're adding here an iscsi transport concept e.g in
the same manner Mike did libiscsi back in 2005/6 when the iser
initiator was pushed. This allows for multiple iscsi flavours to use a
common code  for common functionality. In the initiator area initially
there were iscsi tcp and iser, later few iscsi HW offloads were merged
too. Same story here. I think that the point is whether or not these
APIs are needed, since once we agree on that, we need an header file
and exporting of functions. As libiscsi.h resided under include/ it
makes sense to me for this include to be located there too.

Or.

Or.
