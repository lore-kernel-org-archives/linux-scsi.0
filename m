From: Tejun Heo <tj@kernel.org>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Sat, 22 Aug 2015 09:35:19 -0700
Message-ID: <20150822163519.GA20768@mtj.duckdns.org>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34484 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbbHVQfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2015 12:35:22 -0400
Received: by padfo6 with SMTP id fo6so28468192pad.1
        for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2015 09:35:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, hch@lst.de

Hello,

On Fri, Aug 21, 2015 at 10:37:44PM -0700, Anatol Pomozov wrote:
...
> https://bbs.archlinux.org/viewtopic.php?id=199351 A lot of people
> report the same problem as mine. It was found that the problem appears
> only starting from 3.19, with kernel 3.18 or Windows these drives work
> fine. It is recommended to revert this change
> 9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb "libata: Implement
> ATA_DEV_ZAC" that seems fixes the issue.

Hannes?

-- 
tejun
