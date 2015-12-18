From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/15] be2iscsi: Fix to remove shutdown entry point
Date: Fri, 18 Dec 2015 10:01:24 +0100
Message-ID: <5673CB64.2080006@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-8-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbbLRJBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:01:25 -0500
In-Reply-To: <1450194906-12925-8-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:54 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> Null pointer dereference in shutdown path after taking dump.
>
> Shutdown path is not needed as FW comes up clean every time during pr=
obe
> after issuing FUNCTION reset MBOX command.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |   17 +++--------------
>   drivers/scsi/be2iscsi/be_cmds.h |    2 +-
>   drivers/scsi/be2iscsi/be_main.c |   24 ++++--------------------
>   drivers/scsi/be2iscsi/be_main.h |    3 +--
>   4 files changed, 9 insertions(+), 37 deletions(-)
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
