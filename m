From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 2/2] sg: fixup infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 11:03:16 -0700
Message-ID: <CANn89iLJ4BDdb-Rq38rytzTaiTGOBS2qi2QijJFDmym2aGTMjQ@mail.gmail.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de> <1505477116-75013-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:46028 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdIOSDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 14:03:18 -0400
Received: by mail-ua0-f171.google.com with SMTP id c27so1642163uah.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2017 11:03:17 -0700 (PDT)
In-Reply-To: <1505477116-75013-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, "security@kernel.org" <security@kernel.org>, Hannes Reinecke <hare@suse.com>

On Fri, Sep 15, 2017 at 5:05 AM, Hannes Reinecke <hare@suse.de> wrote:
> When calling SG_GET_REQUEST_TABLE ioctl that only a half-filled
> table is returned; the remaining part will then contain stale
> kernel memory information.
> This patch zeroes out the entire table to avoid this issue.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/sg.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
