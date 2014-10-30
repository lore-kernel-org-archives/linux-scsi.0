From: Hannes Reinecke <hare@suse.de>
Subject: Re: device handler cleanups V2
Date: Thu, 30 Oct 2014 10:39:46 +0100
Message-ID: <54520762.1020002@suse.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325AbaJ3Jjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 05:39:47 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

On 10/30/2014 10:19 AM, Christoph Hellwig wrote:
> This series contains a couple easy cleanups for the device handler
> infrastructure.  I think some more work could be done in the longer r=
un,
> e.g. by using a class_device interface to attach to the scsi_device,
> similar to how the /dev/sg devices work.
>=20
> Changes since V1:
>  - fix ->attach for rdac, pointed out by Mike Christie
>=20
Enumeration appears to be skewed; two patches with 3/6 but none with
5/6 ...

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
