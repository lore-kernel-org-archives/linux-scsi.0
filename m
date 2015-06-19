From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Fri, 19 Jun 2015 09:13:27 +0200
Message-ID: <5583C117.4030103@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de> <20150619064855.GB1183@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbbFSHN3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 03:13:29 -0400
In-Reply-To: <20150619064855.GB1183@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 06/19/2015 08:48 AM, Christoph Hellwig wrote:
> What's the benefit of the SAS transport class writeout?  I honestly
> always saw tcm_loop as a simple loopback driver, with the different
> transport IDs in the PR code as a gimmick.  Note that vhost and
> xen-blkback copies that style and I did plan to consolidate it
> in common code.
>=20
The benefit is that tcm_loop will show up in the system as a 'real'
SAS hba; long-term goal is to simulate SAS multipathing here.
I was even planning on adding simlated FC infrastructure, too;
with that we could simulate FC multipathing, too, and our QA would
be _so_ happy...

Again, these patches are mainly a collection of patches I've done to
test various scenarios, in the hope others might find them useful,
too. So I can easily hold off these patches until you've posted your
rework.

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
