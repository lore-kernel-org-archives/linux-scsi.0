From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Mon, 22 Oct 2007 08:50:45 +0200
Message-ID: <471C4845.20708@suse.de>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain> <20071022034605.GB8421@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:35039 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXJVGut (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2007 02:50:49 -0400
In-Reply-To: <20071022034605.GB8421@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Oct 21, 2007 at 11:19:22AM -0500, James Bottomley wrote:
>> But, I suppose the main point is: is this really necessary?  The
>> default, when unspecified, is 16 bytes and the mid-layer can't deliv=
er
>> anything larger.  I would anticipate the large CDB infrastructure wi=
ll
>> have some separate enabling, so why not simply do nothing until that
>> gets merged?
>=20
> You're sadly mistaken ... the default is 12 byte cdbs:
>=20
>         shost->max_cmd_len =3D 12;
>=20
That's what I thought, too. Hence the patch.
But if we set the default to 16 byte cdbs you can of course ignore
the patch.

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
