From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 0/2] Include protection information in iscsi header
Date: Tue, 3 Jun 2014 10:56:29 +0300
Message-ID: <CAJZOPZKAwUASYVC26O-e=Qv7ziMHJ8FwTBqpfo4TSoqddcxiZg@mail.gmail.com>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
	<CAL1RGDVpPstaXELznXNyUnr_yU95T2ctm63j_Lg0z1P=PY1dYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:43349 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaFCH4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 03:56:31 -0400
In-Reply-To: <CAL1RGDVpPstaXELznXNyUnr_yU95T2ctm63j_Lg0z1P=PY1dYQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Oren Duer <oren@mellanox.com>

On Tue, Jun 3, 2014 at 9:16 AM, Roland Dreier <roland@purestorage.com> wrote:
> On Sun, Jun 1, 2014 at 9:19 AM, Sagi Grimberg <sagig@mellanox.com> wrote:
>> Although these patches involve 3 subsystems with different
>> maintainers (scsi, iser, target) I would prefer seeing these
>> patches included together.
>
> Why?  Because they break wire compatibility?
>
> I hate to say it but even if they're merged at the same time, you
> can't guarantee that targets and initiators will be updated together.

Guys, this all deals with code merged in 3.15-rc1, and (thanks god and
linus that -rc8 took place this cycle) 3.15 isn't out yet!! -- so we
just need to act quickly and this (having the fix in 3.15 or if too
late in 3.15.1) would be OK
