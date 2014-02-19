From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Wed, 19 Feb 2014 10:47:12 +0100
Message-ID: <53047DA0.4030100@suse.de>
References: <1392800681-5290-1-git-send-email-mlombard@redhat.com> <530474D2.4050504@suse.de> <5304780A.6020605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbaBSJrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 04:47:14 -0500
In-Reply-To: <5304780A.6020605@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, kay@vrfy.org

On 02/19/2014 10:23 AM, Maurizio Lombardi wrote:
> Hi Hannes,
>=20
> On 02/19/2014 10:09 AM, Hannes Reinecke wrote:
>> Thanks for doing this.
>>
>> I've actually a full patchset queued, converting all the stray
>> 'printk' invocations in the SCSI stack to dev_printk() and friends.
>> And moving to a per-device scsi_log_level :-)
>>
>> So far I haven't posted them as I'm still waiting for feedback
>> from my EVPD patchset.
>>
>> But I can rebase them on top of that if you want to have a look at t=
hem.
>>
>=20
>=20
> Are you talking about this patchset?
>=20
> "scsi: avoid linebreaks in syslog output"
> http://marc.info/?l=3Dlinux-scsi&m=3D135003083808290&w=3D2
>=20
Sort of. That was the first attempt, but has been seen quite some
updates since then.

> If you have a more complete and up-to-date patchset in your queue
> it would be interesting to have a look at it.
>=20
You can find the current development branch at

git.kernel.org:/pub/scm/linux/kernel/git/hare/scsi-devel
branch scsi-logging.v3

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
