From: Hannes Reinecke <hare@suse.de>
Subject: Re: 64-bit LUN support in Linux kernel?
Date: Mon, 25 Nov 2013 13:16:25 +0100
Message-ID: <52933F99.7060300@suse.de>
References: <1385381014.92441.YahooMailNeo@web121101.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab3KYMQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Nov 2013 07:16:26 -0500
In-Reply-To: <1385381014.92441.YahooMailNeo@web121101.mail.ne1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aleksey Dashevsky <alekseyd@yahoo.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 11/25/2013 01:03 PM, Aleksey Dashevsky wrote:
> Dear Hannes,
>=20
> I'm wondering what happens to your patch set with Linux 64-bit LUN
> support? As far as I understand you'd got few more SCSI related
> patches in your drawer
> (http://www.spinics.net/lists/linux-scsi/msg69428.html), but they
> have been  pushed upstream recently.
>=20
Currently I'm trying to excite any comment from James B. after the
latest respin of my eh-timeout patchset.
In _principle_ the patchset is now clean, and everyone agrees it
should get in. But as long as James B. doesn't react here I don't
see a point in sending my other patches, as they sort of rely on
each other.

Currently I have these patchsets queued:

- eh-timeout
- per-device logging level support
- 64-bit LUN support
- Further EH improvements:
  - remove duplicate hooks
  - move eh_host_reset_handler
    to take 'struct Scsi_Host' as argument,
  etc.

I was planning to send the per-device logging level support
in the next round, as this is touching quite a lot of areas,
but it's probably the most uncontroversial.
64-bit LUN support will be sent afterwards, as this needs some
modifications to the LLDDs, some of which cannot handle
64-bit LUNs without internal modifications. And I would need
to discuss with the vendors of how to handle these issues.

But then, as even the first patchset hasn't moved forward
in the recent weeks I fail to see the point in sending the others,
as I cannot be sure if and when the first one is getting in.

If there is interest I can put these patches up to my git
repository, of course.

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
