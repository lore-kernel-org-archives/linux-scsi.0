From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] vmw_pvscsi: fixup tagging
Date: Sat, 18 Oct 2014 19:42:09 +0200
Message-ID: <5442A671.3080704@suse.de>
References: <1412234501-78199-1-git-send-email-hare@suse.de>,<20141017131651.GD16538@infradead.org> <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaJRRmM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Oct 2014 13:42:12 -0400
In-Reply-To: <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>, Christoph Hellwig <hch@infradead.org>
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/17/2014 08:34 PM, Arvind Kumar wrote:
> Hi Christoph,
>
> Thanks for the change. Sorry for the delay. The change looks fine to =
me. I just have a question.
>
> The comment in include/scsi/scsi_cmnd.h says:
>
> struct scsi_cmnd {
> ...
>               unsigned char tag; /* SCSI-II queued command tag */
> }
>
> Is that comment not right? Should we update that too?
>
The 'tag' field from the scsi_cmnd is indeed meant for the SCSI-II=20
queued command tag. But due to recent changes 'struct request' also
contains a tag number which is used to implement a tag map.
So the 'tag; field from struct scsi_cmnd is basically obsolete,
and we're working on removing it.

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
