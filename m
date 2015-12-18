From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/15] be2iscsi: Fix to handle misconfigured optics events
Date: Fri, 18 Dec 2015 10:02:21 +0100
Message-ID: <5673CB9D.2000005@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-10-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbbLRJCX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:02:23 -0500
In-Reply-To: <1450194906-12925-10-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:55 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> Log messages for misconfigured transceivers reported by FW.
>
> Register async events that driver handles using MCC_CREATE_EXT ioctl.
> Errors messages for faulted/uncertified/unqualified optics are logged=
=2E
> Added IOCTL to get port_name to be displayed in error message.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |  164 ++++++++++++++++++++++++----=
----------
>   drivers/scsi/be2iscsi/be_cmds.h |   47 ++++++++++--
>   drivers/scsi/be2iscsi/be_main.c |   19 +----
>   drivers/scsi/be2iscsi/be_main.h |   10 ++-
>   drivers/scsi/be2iscsi/be_mgmt.c |   42 ++++++++++
>   drivers/scsi/be2iscsi/be_mgmt.h |    2 +
>   6 files changed, 199 insertions(+), 85 deletions(-)
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
