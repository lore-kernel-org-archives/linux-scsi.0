From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17] scsi_dh_alua: Make stpg synchronous
Date: Mon, 11 May 2015 11:59:16 +0200
Message-ID: <55507D74.1070908@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-9-git-send-email-hare@suse.de> <20150511065523.GG30516@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148AbbEKJ7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 05:59:20 -0400
In-Reply-To: <20150511065523.GG30516@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 05/11/2015 08:55 AM, Christoph Hellwig wrote:
> On Mon, May 04, 2015 at 02:42:14PM +0200, Hannes Reinecke wrote:
>> We should be issuing STPG synchronously as we need to
>> evaluate the return code on failure.
>=20
> How does this fit into the calling convention?  It seems like general=
ly
> dm-mpath expects async execution of ->activate.  If we don't actually=
 need
> asynchronous activation we should remove it from all the drivers to h=
ave
> a consistent calling convention.
>=20
This is just an intermediate step, before the entire thing moves off
to a workqueue and becomes asynchronous again.
It's not meant to be as a standalone patch; I've just split it off
for easier review.

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
