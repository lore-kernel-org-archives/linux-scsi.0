From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 4077] New: kernel oops with Fusion MPT
	SCSI driver
Date: Fri, 21 Jan 2005 16:01:07 -0800
Message-ID: <1106352067.5932.15.camel@mulgrave>
References: <20050121153214.2468cbc5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:20190 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262606AbVAVABZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2005 19:01:25 -0500
In-Reply-To: <20050121153214.2468cbc5.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, jd@ts.ray.fi
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-01-21 at 15:32 -0800, Andrew Morton wrote:
>     NIP [c00000000007f94c] .free_block+0xf0/0x1b8
>     LR [c00000000007fad8] .drain_array_locked+0xc4/0x138
>     Call Trace:
>     [c00000000ff8fb80] [c00000000ff8fc20] 0xc00000000ff8fc20 (unreliable)
>     [c00000000ff8fc30] [c00000000007fad8] .drain_array_locked+0xc4/0x138
>     [c00000000ff8fcd0] [c000000000081100] .cache_reap+0xc4/0x2b4

This is a problem in the slab management isn't it?

Could we try getting the reporter to try with slab debugging turned on?

James


