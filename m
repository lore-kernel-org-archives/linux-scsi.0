From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh: convert __ATTR macro to DEVICE_ATTR_RW and snprintf
 show method cleanup
Date: Mon, 29 Jun 2015 13:40:03 +0200
Message-ID: <55912E93.1000403@suse.de>
References: <DDB9C85B850785449757F9914A034FCB3F8EAA39@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbbF2LkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2015 07:40:05 -0400
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3F8EAA39@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>

On 06/26/2015 08:38 AM, Seymour, Shane M wrote:
>=20
> Converted dh_state to use DEVICE_ATTR_RW macro
> instead of __ATTR.  That forced a change to the associated
> show/store function names and the name of the attribute.
>=20
> Changed usage of snprintf in show function to scnprintf per
> Documentation/filesystems/sysfs.txt.
>=20
> Signed-off-by: Shane Seymour <shane.seymour@hp.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Note that I'm currently preparing a device handler update, based
upon an earlier patchset from hch.

I'll be folding this patch into it, unless it'll be picked up earlier.

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
