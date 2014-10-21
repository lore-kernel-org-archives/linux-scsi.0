From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 00/27] scsi logging update (the boring part)
Date: Tue, 21 Oct 2014 13:02:48 +0200
Message-ID: <54463D58.60906@suse.de>
References: <1413787950-14659-1-git-send-email-hare@suse.de> <20141021105538.GA1950@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaJULCt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2014 07:02:49 -0400
In-Reply-To: <20141021105538.GA1950@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On 10/21/2014 12:55 PM, Christoph Hellwig wrote:
> On Mon, Oct 20, 2014 at 08:52:03AM +0200, Hannes Reinecke wrote:
>> here is now the seventh iteration of my scsi logging update.
>> With this I've included another patch for ratelimiting
>> I/O error messages, which resolves the outstanding issue
>> noted by Robert Elliot.
>=20
> What tree is this against?  This doesn't seem to touch the ufs driver=
,
> which in 3.18-rc has grown calls to some of the functions you remove.
>=20
Hmm. I _thought_ to have it done against core-for-3.18; but I'll
double check ...

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
