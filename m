From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/8] target_core_alua: disallow READ_CAPACITY when in
 standby
Date: Fri, 19 Jun 2015 09:07:47 +0200
Message-ID: <5583BFC3.4020207@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de> <1434620622-65391-8-git-send-email-hare@suse.de> <20150619064951.GC1183@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbbFSHHt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 03:07:49 -0400
In-Reply-To: <20150619064951.GC1183@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 06/19/2015 08:49 AM, Christoph Hellwig wrote:
> On Thu, Jun 18, 2015 at 11:43:41AM +0200, Hannes Reinecke wrote:
>> Strictly speaking SPC doesn't require READ CAPACITY and friends
>> to be supported while in the port is in standby.
>=20
> But it does allow it.  We should always aim to implement the best
> possible behavior instead of aiming for the worst.
>=20
Right. As mentioned in my other mail this patch was primarily to
fixup READ CAPACITY issues in the linux kernel.
I'll be updating the patch to make it optional.

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
