From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [linux-iscsi-devel] [question] deferred sense
Date: Wed, 05 Jan 2005 16:51:57 -0500
Message-ID: <1104961917.3883.4.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B9B94AF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39648 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262633AbVAEWtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 17:49:03 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B9B94AF@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-05 at 12:47 -0500, Salyzyn, Mark wrote:
> Change the assumptions in Journalling filesystems and make it work in a
> deferred sense environment.

It's possible, but I think it will involve large changes to the kernel.

> Don't delete the Journal until a safe point of time when the writeback
> is confirmed either by underlying knowledge, time (flush interval
> passed), amount of data (dirty cache is forced flushed), or a read-back
> (resulting from the deferred error investigation). RAID cards and
> external enclosures do this all the time, but to be fair with usually
> more knowledge of all the cache handling.

Well ... this proposal would change every filesystem in the kernel for
something that occurs rather rarely (I've never actually seen it
happen), so it is rather a lot of work for not very much benefit.
However, if you have actual proposals, lets see them.

I suggest you publish the API to linux-scsi and linux-ide since we'd be
the primary implementers.  The fs changes should go to the relevant fs
lists (probably cc linux-kernel) and we'll be glad to look them over.

James


