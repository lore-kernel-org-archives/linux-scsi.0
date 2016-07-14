From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 1/3] ata: bump ATA_MAX_SECTORS_LBA48 to 65536
Date: Thu, 14 Jul 2016 14:26:10 -0400
Message-ID: <20160714182610.GP15005@htj.duckdns.org>
References: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
 <20160713170308.GF4065@mtj.duckdns.org>
 <CAGnHSE=0Bwg6NcBRfcixSncT7-7y5Z6hBfjireSr1MawShHVVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:35867 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbcGNS0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2016 14:26:13 -0400
Content-Disposition: inline
In-Reply-To: <CAGnHSE=0Bwg6NcBRfcixSncT7-7y5Z6hBfjireSr1MawShHVVA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Jul 15, 2016 at 02:22:52AM +0800, Tom Yan wrote:
> On 14 July 2016 at 01:03, Tejun Heo <tj@kernel.org> wrote:
> >
> > It's used to device max_sectors.
> >
> 
> Not really. "max_sectors" of ATA drives have been set to
> BLK_DEF_MAX_SECTORS, for at least quite some time.
> 
> >
> > This is way too gratuitous.  There's no rationale for it while it has
> > actual real-world risks.  max_sectors is staying at 65535.
> >
> 
> That's alright. I don't have strong opinion on whether we should bump
> this anyway. So I suppose we should replace the TODO comment with
> something like "avoid count to be 0000h"? And maybe also change
> ATA_MAX_SECTORS to 255 (with comment "avoid count to be 00h")?

I'd just leave both alone.  It's one sector difference one way or the
other and those numbers have a pretty long history.  There's no reason
to disturb them at this point.  There's no actual gain whatsoever but
there is some actual risk.

Thanks.

-- 
tejun
