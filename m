From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Tue, 22 Nov 2016 22:55:44 +0200
Message-ID: <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
 <1479839407.28416.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33172 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756778AbcKVUzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 15:55:50 -0500
Received: by mail-io0-f196.google.com with SMTP id j92so12869768ioi.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 12:55:45 -0800 (PST)
In-Reply-To: <1479839407.28416.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, dgilbert@interlog.com, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Nov 22, 2016 at 8:30 PM, Ewan D. Milne <emilne@redhat.com> wrote:
>
> I see the behavior (zero byte) on the 4.4.34, 4.5.7, 4.6.7, and 4.7.10
> -stable kernels.  But not (of course) on 4.8.10 -stable.
>
> It doesn't look like the sg driver, might be something in the mmap code?


A kernel guy colleague suggested to look at copy_from_user / copy_to_user code.
It was changed in 4.8

It was OK with 3.13  (Ubuntu 14.04) but from some kernel (prior or equal to 4.4)
until 4.7 we see the bug. It was somehow fixed at 4.8.

In order to fully understand what happened, there are two changes to find.
They might not even be related.

Thanks!
Eyal
