From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND] interest in blk-mq, scsi-mq, dm-cache, dm-thinp,
 dm-*
Date: Mon, 13 Jan 2014 12:36:18 +0100
Message-ID: <52D3CFB2.4010207@suse.de>
References: <20140110182714.GA11731@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaAMLgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 06:36:19 -0500
In-Reply-To: <20140110182714.GA11731@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org

On 01/10/2014 07:27 PM, Mike Snitzer wrote:
> I would like to attend to participate in discussions related to topic=
s
> listed in the subject.  As a maintainer of DM I'd be interested to
> learn/discuss areas that should become a development focus in the mon=
ths
> following LSF.
>=20
+1

I've been thinking on (re-) implementing multipathing on top of
blk-mq, and would like to discuss the probability of which.
There are some design decisions in blk-mq (eg statically allocating
the number of queues) which do not play well with that.

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
