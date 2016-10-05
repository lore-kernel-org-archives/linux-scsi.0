From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: iscsi_trx going into D state
Date: Wed, 5 Oct 2016 12:19:06 -0600
Message-ID: <CAANLjFrUhiDu8ryuVOa9dEDQG2V3UNgwAL=QU3b9iUo0yjTiGw@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <20161004075545.j52mg3a2jckrchlp@linux-x5ow.site> <5cfc7eb8-c59d-4b7a-3dee-99e17d72f251@suse.de>
 <20161004114642.GA2377@infradead.org> <CAANLjFrNz45nizmPa7XH4Hpw7e-KScGCsaMpXWG0BCNhuXxOCg@mail.gmail.com>
 <20161005180305.GA2900@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33907 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbcJESTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2016 14:19:08 -0400
Received: by mail-oi0-f67.google.com with SMTP id r132so12779002oig.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Oct 2016 11:19:07 -0700 (PDT)
In-Reply-To: <20161005180305.GA2900@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

Thanks, we will apply that too. We'd like to get this stable. We'll
report back on what we find with these patches.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Oct 5, 2016 at 12:03 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Hi Robert,
>
> I actually got the name wrong, the patch wasn't from Lee, but from Zhu,
> another SuSE engineer.  This is the one:
>
> http://www.spinics.net/lists/target-devel/msg13463.html
