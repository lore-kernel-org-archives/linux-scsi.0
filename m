From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi_dh_emc: fix mode select request setup
Date: Mon, 07 Dec 2009 12:04:24 +0100
Message-ID: <4B1CE138.3050404@suse.de>
References: <1259785728-20419-1-git-send-email-michaelc@cs.wisc.edu> <1259786182.5430.138.camel@mulgrave.site> <4B16D220.90108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbZLGLET (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 06:04:19 -0500
In-Reply-To: <4B16D220.90108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> James Bottomley wrote:
>> On Wed, 2009-12-02 at 14:28 -0600, michaelc@cs.wisc.edu wrote:
>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>
>>> This patch fixes the request setup code for mode selects. I got the
>>> fixes from
>>> Hannes Reinecke while trying to hunt down some problems and merged =
it
>>> into one patch. I am sending it because Hannes is busy with other
>>> things.
>>
>> So that should be From: Hannes Reineke at the top then?  (I can fix =
it
>> up if it is)
>>
>=20
> Yeah, I think it should. I was not sure, because I merged his fixes i=
nto
> one patch and wrote the email. He wrote all the code though. I am jus=
t
> forwarding the fixes since he was busy.

Thanks Mike.

Yes, James, just update the 'From' header.

Provided you spell my name correctly :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
