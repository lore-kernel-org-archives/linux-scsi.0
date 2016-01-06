From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [PATCH 01/35] block/fs/drivers: remove rw argument
 from submit_bio
Date: Wed, 6 Jan 2016 16:59:26 +0100
Message-ID: <568D39DE.2060709@sandisk.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <1452027218-32303-2-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0077.outbound.protection.outlook.com ([157.56.110.77]:38432
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998AbcAFP7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2016 10:59:38 -0500
In-Reply-To: <1452027218-32303-2-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

On 01/05/2016 09:53 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>
> This has callers of submit_bio/submit_bio_wait set the bio->bi_rw
> instead of passing it in. This makes that use the same as
> generic_make_request and how we set the other bio fields.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
