From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] gdth: Fixup section annotations
Date: Mon, 13 Jan 2014 09:23:48 +0100
Message-ID: <52D3A294.2040108@suse.de>
References: <1389367888-117607-1-git-send-email-hare@suse.de> <1389373643.4066.0.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAMIXu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 03:23:50 -0500
In-Reply-To: <1389373643.4066.0.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/10/2014 06:07 PM, James Bottomley wrote:
> On Fri, 2014-01-10 at 16:31 +0100, Hannes Reinecke wrote:
>> Fixup section annotations so that kbuild doesn't complain anymore.
>=20
> This doesn't look right: __devinit is now an obsolete annotation.
>=20
Hmm. Patch has been in our internal kernel repository for ages.
I'll be checking.

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
