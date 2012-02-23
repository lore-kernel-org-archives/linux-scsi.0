From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi scan: don't fail scans when host is in recovery
Date: Thu, 23 Feb 2012 08:21:39 +0100
Message-ID: <4F45E903.2010909@suse.de>
References: <1314250598-2852-1-git-send-email-michaelc@cs.wisc.edu> <4F44BBEA.3020400@suse.de> <4F4553DC.7000500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2BWHVl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2012 02:21:41 -0500
In-Reply-To: <4F4553DC.7000500@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 02/22/2012 09:45 PM, Mike Christie wrote:
> On 02/22/2012 03:56 AM, Hannes Reinecke wrote:
>>> ---
>>>  include/scsi/scsi_host.h |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>>> index f1f2644..22b7b23 100644
>>> --- a/include/scsi/scsi_host.h
>>> +++ b/include/scsi/scsi_host.h
>>> @@ -791,7 +791,8 @@ static inline struct device *scsi_get_device(st=
ruct Scsi_Host *shost)
>>>   **/
>>>  static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
>>>  {
>>> -	return shost->shost_state =3D=3D SHOST_RUNNING;
>>> +	return shost->shost_state =3D=3D SHOST_RUNNING ||
>>> +	       shost->shost_state =3D=3D SHOST_RECOVERY;
>>>  }
>>> =20
>>>  extern void scsi_unblock_requests(struct Scsi_Host *);
>>
>> James, ping?
>> Any reason it was not included?
>>
>=20
> It is merged in git commit 76e4e12ff2b3ef86773989fd897b194eb38016e6.

I must be blind

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
