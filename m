From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 7/9] snic:Add sysfs entries to list stats and trace
 data
Date: Fri, 29 May 2015 16:05:29 +0200
Message-ID: <55687229.8060500@suse.de>
References: <1432886649-12034-1-git-send-email-nmusini@cisco.com> <1432886649-12034-8-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbbE2OFb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 May 2015 10:05:31 -0400
In-Reply-To: <1432886649-12034-8-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, boaz@plexistor.com, jthumshirn@suse.de
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 05/29/2015 10:04 AM, Narsimhulu Musini wrote:
> snic_stats.h contains stats structre definitions for various events
> in snic driver.
>=20
> snic_debugfs.c contains setup and cleanup of sysfs entries for listin=
g stats,
> resetting stats, enabling/disabling trace, and listing trace data.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
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
