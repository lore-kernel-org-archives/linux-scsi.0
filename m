From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/15] be2iscsi: Fix mbox synchronization replacing
 spinlock with mutex
Date: Fri, 18 Dec 2015 09:59:06 +0100
Message-ID: <5673CADA.7020905@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-3-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081AbbLRI7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 03:59:08 -0500
In-Reply-To: <1450194906-12925-3-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:54 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> This is second part of actual fix for soft lockup.
>
> All mbox cmds issued using BMBX and MCC are synchronized using mutex
> mbox_lock instead of spin_lock. Used mutex_lock_interruptible where
> ever possible.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be.h      |    2 +-
>   drivers/scsi/be2iscsi/be_cmds.c |   73 ++++++++++++++-------------
>   drivers/scsi/be2iscsi/be_main.c |    2 +-
>   drivers/scsi/be2iscsi/be_mgmt.c |  105 ++++++++++++++++++++--------=
----------
>   4 files changed, 94 insertions(+), 88 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
