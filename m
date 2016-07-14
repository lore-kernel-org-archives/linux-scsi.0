From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC 1/3] ata: bump ATA_MAX_SECTORS_LBA48 to 65536
Date: Fri, 15 Jul 2016 02:22:52 +0800
Message-ID: <CAGnHSE=0Bwg6NcBRfcixSncT7-7y5Z6hBfjireSr1MawShHVVA@mail.gmail.com>
References: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
 <20160713170308.GF4065@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33212 "EHLO
	mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcGNSWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2016 14:22:53 -0400
In-Reply-To: <20160713170308.GF4065@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 14 July 2016 at 01:03, Tejun Heo <tj@kernel.org> wrote:
>
> It's used to device max_sectors.
>

Not really. "max_sectors" of ATA drives have been set to
BLK_DEF_MAX_SECTORS, for at least quite some time.

>
> This is way too gratuitous.  There's no rationale for it while it has
> actual real-world risks.  max_sectors is staying at 65535.
>

That's alright. I don't have strong opinion on whether we should bump
this anyway. So I suppose we should replace the TODO comment with
something like "avoid count to be 0000h"? And maybe also change
ATA_MAX_SECTORS to 255 (with comment "avoid count to be 00h")?
