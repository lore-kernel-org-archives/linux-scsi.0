From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/17] scsi_dh_alua: revert commit a8e5a2d593cbfccf530c3382c2c328d2edaa7b66
Date: Mon, 11 May 2015 12:00:36 +0200
Message-ID: <55507DC4.3000800@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-14-git-send-email-hare@suse.de> <20150511070025.GI30516@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbbEKKAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 06:00:37 -0400
In-Reply-To: <20150511070025.GI30516@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/11/2015 09:00 AM, Christoph Hellwig wrote:
> On Mon, May 04, 2015 at 02:42:19PM +0200, Hannes Reinecke wrote:
>> Obsoleted by the next patch.
>=20
> Please use a descriptive subject, and the mention the commit name in =
the
> message body in the canonical format:  commit a8e5a2 ("[SCSI] scsi_dh=
_alua:
> ALUA handler attach should succeed while TPG is transitioning");
>=20
Okay.

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
