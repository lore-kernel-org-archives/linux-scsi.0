From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Fri, 17 Jun 2016 08:59:47 +0200
Message-ID: <57639FE3.3080502@suse.de>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de> <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de> <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
 <5760F6BC.60109@suse.de> <576127FC.9020608@kernel.dk>
 <57612F12.5070505@suse.de> <5761838E.1000106@linux.vnet.ibm.com>
 <57629D23.1090704@linux.vnet.ibm.com> <5763215D.4040600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbcFQG7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2016 02:59:52 -0400
In-Reply-To: <5763215D.4040600@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On 06/16/2016 11:59 PM, Mauricio Faria de Oliveira wrote:
> On 06/16/2016 09:35 AM, Mauricio Faria de Oliveira wrote:
>> On 06/15/2016 01:34 PM, Brian King wrote:
>>> [...] did you ever try to reproduce this with an
>>> upstream
>>> kernel?
>
>> Now that the topic is under discussion, I've asked for some time slo=
ts
>> on that system, so we can test an upstream kernel and try to reprodu=
ce
>> the problem and analyze it more closely.
>
> The problem is not reproducible w/ 4.7.0-rc3 even after a few hours;
> it is instantly reproducible w/ 3.12.57-60.35 (SLES 12 SP1 updates).
>
> Hannes et al,
>
> If you'd like some data collection from this system, feel free to pin=
g
> me about it.
>
Ouch.

Okay, continue discussion on the SUSE bugzilla.
Guess we've missed some backports then.

Sorry for the noise.

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
