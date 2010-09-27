From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SCSI: remove noop in fc_remote_port_add()
Date: Mon, 27 Sep 2010 09:09:48 +0200
Message-ID: <4CA0433C.8070301@suse.de>
References: <AANLkTik-pmP9_ovxiX+SBD2AvxtsWbtj2F-RJbL3w+AY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0I0HJv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 03:09:51 -0400
In-Reply-To: <AANLkTik-pmP9_ovxiX+SBD2AvxtsWbtj2F-RJbL3w+AY@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@suse.de>

Hillf Danton wrote:
> For a deleted scsi target marked as FC_PORTSTATE_BLOCKED,  rescanning
> it looks fine.
>=20
Note that there has been an earlier patch by Christof Schmitt, which
does exactly the same thing plus a slightly more in-depth analysis.
Check for 'scsi: Remove QUEUE_FLAG_REENTER from SCSI code'.

James, comments?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
