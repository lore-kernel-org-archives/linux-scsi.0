From: Hannes Reinecke <hare@suse.de>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 11:22:56 +0200
Message-ID: <53C3A170.1070101@suse.de>
References: <20140714083547.GA6315@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaGNJW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 05:22:59 -0400
In-Reply-To: <20140714083547.GA6315@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com
Cc: linux-scsi@vger.kernel.org

On 07/14/2014 10:35 AM, Christoph Hellwig wrote:
> Back when the mpt3sas driver was first posted I suggested that it sho=
uld
> be merged into mpt2sas, but my proposal didn't get much traction.
>
> Illumos has now produced a shared driver and shown that the differenc=
e
> are basically limited to a different S/G list format [1], and a quick
> experiment on the Linux drivers confirms this mostly - the additional
> differences are various smaller workarounds for specific hardware
> revisions.
>
> I think we'd all be served much better with a merged driver.
>
> [1] http://thread.gmane.org/gmane.os.illumos.devel/17341

Please. Pretty please.

I've started a merge myself, but then never found time to finalize it.

Carrying three basically identical drivers just creates a=20
maintenance overhead for everyone involved.

The original idea of splitting the driver and just maintaining the=20
latest has never really worked out; all fixes to the latest driver=20
turned out to be applicable to the others, too.
So it just increased the workload for the maintainer for no real=20
gain. I would _strongly_ vote for it.

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
