From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/22] advansys: Remove comment around cmd_per_lun
Date: Fri, 24 Apr 2015 11:47:04 +0200
Message-ID: <553A1118.7060208@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de> <1429864377-67002-20-git-send-email-hare@suse.de> <20150424094103.GA23248@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966917AbbDXJrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 05:47:07 -0400
In-Reply-To: <20150424094103.GA23248@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 04/24/2015 11:41 AM, Christoph Hellwig wrote:
> On Fri, Apr 24, 2015 at 10:32:54AM +0200, Hannes Reinecke wrote:
>> Ancient, and pretty much obsolete by now.
>=20
> And still doesn't address the fixme.  You probably should remove the
> cmd_per_lun setting entirely.
>=20
Okay, will do.

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
