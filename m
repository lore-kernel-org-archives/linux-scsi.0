From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Mon, 22 Oct 2007 13:57:36 +0200
Message-ID: <471C9030.6030700@suse.de>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain> <20071022034605.GB8421@parisc-linux.org> <471C4845.20708@suse.de> <20071022112345.GC8421@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:34813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbXJVL5i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2007 07:57:38 -0400
In-Reply-To: <20071022112345.GC8421@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Oct 22, 2007 at 08:50:45AM +0200, Hannes Reinecke wrote:
>> That's what I thought, too. Hence the patch.
>> But if we set the default to 16 byte cdbs you can of course ignore
>> the patch.
>=20
> I think the comment in hosts.c explains why we shouldn't do that ...
>=20
_I_ certainly wouldn't. But if the maintainer says so :-)

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
