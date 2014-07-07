From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Mon, 07 Jul 2014 07:47:41 +0200
Message-ID: <53BA347D.3020807@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-2-git-send-email-hare@suse.de> <53B70404.9080303@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaGGFro (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 01:47:44 -0400
In-Reply-To: <53B70404.9080303@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 07/04/2014 09:44 PM, Douglas Gilbert wrote:
> On 14-07-04 07:54 AM, Hannes Reinecke wrote:
>> SCSI-2 defines only up to 256 LUNs with a flat namespace.
>
> My SCSI-2 draft (revision 10b from August 1989) only has
> 3 bit LUNs placed in byte 1 of the command block, in the top
> 3 bits. There are also things called LUNTARs and LUNTRNs
> at the message level.
>
> 8 bit LUNs do ring a distant bell, perhaps after SCSI-2?
>
Yeah, you're right. SCSI-2 defines a 3-byte LUN; starting with SCSI-3 i=
t=20
went to 64bit.

I'll be renaming them to 'sdev_lun8'.

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
