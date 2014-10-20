From: Arvind Kumar <arvindkumar@vmware.com>
Subject: RE: [PATCH] vmw_pvscsi: fixup tagging
Date: Mon, 20 Oct 2014 22:12:46 +0000
Message-ID: <1690691e34434a6d9cb690a655897613@EX13-MBX-025.vmware.com>
References: <1412234501-78199-1-git-send-email-hare@suse.de>,<20141017131651.GD16538@infradead.org>
 <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>,<5442A671.3080704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37030 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbaJTWNA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2014 18:13:00 -0400
In-Reply-To: <5442A671.3080704@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks Hannes and Christoph for the answers. The patch to vmw_pvscsi.c =
looks fine to me.

Acked-by: Arvind Kumar <arvindkumar@vmware.com>

Thanks!
Arvind
________________________________________
=46rom: Hannes Reinecke <hare@suse.de>
Sent: Saturday, October 18, 2014 10:42 AM
To: Arvind Kumar; Christoph Hellwig
Cc: pv-drivers@vmware.com; James Bottomley; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] vmw_pvscsi: fixup tagging

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
The 'tag' field from the scsi_cmnd is indeed meant for the SCSI-II
queued command tag. But due to recent changes 'struct request' also
contains a tag number which is used to implement a tag map.
So the 'tag; field from struct scsi_cmnd is basically obsolete,
and we're working on removing it.

Cheers,

Hannes
--
Dr. Hannes Reinecke                   zSeries & Storage
hare@suse.de                          +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
