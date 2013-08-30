From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/9] virtio_scsi: Enable new EH timeout handler
Date: Fri, 30 Aug 2013 14:47:43 +0200
Message-ID: <5220946F.2050001@suse.de>
References: <1377783140-57191-1-git-send-email-hare@suse.de> <1377783140-57191-5-git-send-email-hare@suse.de> <20130830124541.GA4107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3H3Mrq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Aug 2013 08:47:46 -0400
In-Reply-To: <20130830124541.GA4107@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On 08/30/2013 02:45 PM, Christoph Hellwig wrote:
>> =20
>> +static enum blk_eh_timer_return virtscsi_timedout(struct scsi_cmnd =
*scmd)
>> +{
>> +	scsi_abort_command(scmd);
>> +	return BLK_EH_SCHEDULED;
>> +}
>=20
> just set the method vector to scsi_abort_command here and in all the
> other trivial conversions instead of having all those pointless
> wrappers.
>=20
Ok.

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
