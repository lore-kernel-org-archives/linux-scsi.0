From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] target: display 'write_protect' attribute for demo-mode
 LUNs
Date: Fri, 19 Jun 2015 09:05:58 +0200
Message-ID: <5583BF56.6090708@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de> <1434620622-65391-9-git-send-email-hare@suse.de> <20150619065143.GD1183@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbFSHGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 03:06:00 -0400
In-Reply-To: <20150619065143.GD1183@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 06/19/2015 08:51 AM, Christoph Hellwig wrote:
> On Thu, Jun 18, 2015 at 11:43:42AM +0200, Hannes Reinecke wrote:
>> When LUNs are mapped with a demo-mode initiator we're missing
>> the 'write_protect' attribute to set a LUN read-only.
>=20
> I don't think it's a good idea as-is.  The target core clearly
> differenciates between demo mode and production mode read only, and s=
ome
> drivers already expose attributes for these.
>=20
> I have a big series in progress to clean the mess around this area
> up.  So for now please don't add anything here, it should become much
> simpler after my changes, and I might be able to incorporate somethin=
g
> like this after the main series.
>=20
I've done this particular patch to simulate write-protected LUNs via
tcm_loop. As the hooks already had been there I thought this to be
the 'cleanest' approach.

Of course, if you have other suggestions on how this should be
achieved I'm happy to try this.

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
