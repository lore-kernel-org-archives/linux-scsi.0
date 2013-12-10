From: Hannes Reinecke <hare@suse.de>
Subject: Re: 64-bit LUN support in Linux kernel?
Date: Tue, 10 Dec 2013 12:14:11 +0100
Message-ID: <52A6F783.6080605@suse.de>
References: <1385381014.92441.YahooMailNeo@web121101.mail.ne1.yahoo.com> <52933F99.7060300@suse.de> <1385390632.22761.YahooMailNeo@web121104.mail.ne1.yahoo.com> <1385645372.8003.YahooMailNeo@web121105.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab3LJLON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 06:14:13 -0500
In-Reply-To: <1385645372.8003.YahooMailNeo@web121105.mail.ne1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aleksey Dashevsky <alekseyd@yahoo.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 11/28/2013 02:29 PM, Aleksey Dashevsky wrote:
> Hannes,
>=20
> thanks a lot for your detailed response.  It would be really great
> if you can give access to your local git repository with all these
> patches --  I'm mainly interested in 64-bit LUNs stuff right now,
> but I'm pretty sure  improvements into error handling mechanism are
> crucial. Hope I will be able to provide you with a feedback rather
> soon. If you need me to settle any legal issue -- please let me know.
>=20
So, as you might've seen I've posted the 64-bit LUN patchset to
linux-scsi.

You can access the patches also from my git repository at

git://git.kernel.org/pub/scm/linux/kernel/hare/scsi-devel.git branch
64bit-luns

HTH.

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
