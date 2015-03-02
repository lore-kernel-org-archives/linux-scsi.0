From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/9] snic:Add sysfs entries to list stats and trace data
Date: Mon, 02 Mar 2015 14:33:31 +0100
Message-ID: <54F466AB.7000604@suse.de>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com> <1423586616-18177-8-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbbCBNdc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2015 08:33:32 -0500
In-Reply-To: <1423586616-18177-8-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
> snic_stats.h contains stats structre definitions for various events
> in snic driver.
>=20
> snic_debugfs.c contains setup and cleanup of sysfs entries for listin=
g stats,
> resetting stats, enabling/disabling trace, and listing trace data.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
