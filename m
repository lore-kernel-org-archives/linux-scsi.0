From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Wed, 19 Feb 2014 10:09:38 +0100
Message-ID: <530474D2.4050504@suse.de>
References: <1392800681-5290-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbaBSJJl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 04:09:41 -0500
In-Reply-To: <1392800681-5290-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, kay@vrfy.org

On 02/19/2014 10:04 AM, Maurizio Lombardi wrote:
> This patch converts the st driver to use dev_printk() instead of prin=
tk(),
> every st device has a reference to the underlying scsi device.
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Thanks for doing this.

I've actually a full patchset queued, converting all the stray
'printk' invocations in the SCSI stack to dev_printk() and friends.
And moving to a per-device scsi_log_level :-)

So far I haven't posted them as I'm still waiting for feedback
from my EVPD patchset.

But I can rebase them on top of that if you want to have a look at them=
=2E

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
