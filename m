From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/22] scsi: Use sdev as argument for sense code printing
Date: Mon, 01 Sep 2014 10:00:13 +0200
Message-ID: <5404278D.6010507@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-6-git-send-email-hare@suse.de> <20140831215538.GA16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaIAIAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:00:14 -0400
In-Reply-To: <20140831215538.GA16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 08/31/2014 11:55 PM, Christoph Hellwig wrote:
>> -scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
>> +scsi_extd_sense_format(unsigned char asc, unsigned char ascq,
>> +		       const char **fmt) {
>=20
> please move the opening brace to a new line per normal Linux style.
>=20
Done.

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
