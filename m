From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] scsi: scsi_check_sense HARDWARE_ERROR return ADD_TO_MLQUEUE
Date: Mon, 25 Aug 2008 14:34:50 +0200
Message-ID: <48B2A6EA.7010304@suse.de>
References: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com> <1218568318-4065-3-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:48972 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYHYMew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 08:34:52 -0400
In-Reply-To: <1218568318-4065-3-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Chandra Seetharaman <sekharan@us.ibm.com>

Hi Mike,

Mike Anderson wrote:
> Change scsi_check_sense HARDWARE_ERROR check to return ADD_TO_MLQUEUE
> to allow retries to occur without restriction of blk_noretry_request
> check.
Correct. We always should retry here.

>=20
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
