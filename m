From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] scsi: remove scsi_next_command
Date: Tue, 11 Nov 2014 20:02:46 +0100
Message-ID: <54625D56.20308@suse.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-3-git-send-email-hch@lst.de> <545B2F71.7020808@suse.de> <20141106153413.GA22415@lst.de> <20141111163748.GA13445@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaKKTCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2014 14:02:48 -0500
In-Reply-To: <20141111163748.GA13445@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

On 11/11/2014 05:37 PM, Christoph Hellwig wrote:
> On Thu, Nov 06, 2014 at 04:34:13PM +0100, Christoph Hellwig wrote:
>> On Thu, Nov 06, 2014 at 09:21:05AM +0100, Hannes Reinecke wrote:
>>> Hmm? Isn't there a scsi_put_comand() too many?
>>> You dropped it from the 'if' branch, moved it out of
>>> the condition, but kept in in the 'else' branch ...
>>
>> The put_device for the 'else' branch was hidden inside scsi_next_com=
mand.
>=20
> Is this a good enough explanation to get a Reviewed-by?
>=20
Yep.

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
