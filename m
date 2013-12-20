From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] scsi: avoid linebreaks in syslog output
Date: Fri, 20 Dec 2013 14:31:42 +0100
Message-ID: <52B446BE.20901@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de> <52B44548.8020308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab3LTNbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 08:31:44 -0500
In-Reply-To: <52B44548.8020308@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 12/20/2013 02:25 PM, Tomas Henzl wrote:
> Hi Hannes, James,
>=20
> I'm wondering what happened to this patch-set? I think it could
> make parsing of the output for userspace programs much easier.
> Are there some problems still to solve or is this just forgotten?
>=20
Oh, no. Quite the contrary.
As James has now merged my previous patchsets I'm in the process of
updating this one, too.

It'll be part of a larger patchset having a per-device
scsi_logging_level; something I was wanting to have for a _LONG_
time now.

Currently I'm fiddling with sense code printing, so I won't be able
to send anything this year. But early next year I should have
something presentable.

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
