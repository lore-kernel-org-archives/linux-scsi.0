From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sr: consider the last written sector when determining
 media size
Date: Tue, 15 Sep 2009 06:54:02 +0900
Message-ID: <4AAEBB7A.3060700@kernel.org>
References: <4AA07D8A.6090004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AA07D8A.6090004@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Milan Kocian <milan.kocian@wq.c>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> On certain cases, UDF disc doesn't report capacity correctly via
> READ_CAPACITY but TOC or trackinfo contains valid information which
> can be obtained using cdrom_get_last_written().  ide-cd considers both
> values and uses the larger one.  Do the same in sr.  This fixes
> bko#9668.
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=9668
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Milan Kocian <milan.kocian@wq.cz>
> Cc: Jan Kara <jack@suse.cz>

PING.

-- 
tejun
