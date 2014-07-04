From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Fri, 04 Jul 2014 16:12:22 +0200
Message-ID: <53B6B646.5080301@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-2-git-send-email-hare@suse.de> <20140704134437.GA12345@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbaGDOMZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 10:12:25 -0400
In-Reply-To: <20140704134437.GA12345@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/04/2014 03:44 PM, Christoph Hellwig wrote:
> On Fri, Jul 04, 2014 at 01:54:34PM +0200, Hannes Reinecke wrote:
>> SCSI-2 defines only up to 256 LUNs with a flat namespace.
>> This patch introduces an accessor 'sdev_scsi2lun' which should be
>> used for these drivers to avoid problems when using 64-bit LUNs
>> internally.
>
> So what would be set in the upper 48 bits for those drivers?  We rece=
ive
> the LUN over the wire to start with.
>
None. All these devices are physically incapable of receiving or=20
sending LUNs more that a byte wide.

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
