From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 7/9] snic:Add sysfs entries to list stats and trace
 data
Date: Thu, 09 Apr 2015 15:23:50 +0200
Message-ID: <55267D66.8020509@suse.de>
References: <1428580189-22785-1-git-send-email-nmusini@cisco.com> <1428580189-22785-8-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbbDINXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2015 09:23:53 -0400
In-Reply-To: <1428580189-22785-8-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/09/2015 01:49 PM, Narsimhulu Musini wrote:
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
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
