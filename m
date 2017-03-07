From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCHv2] hpsa: expose enclosures
Date: Tue, 7 Mar 2017 16:33:28 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F331BC9@avsrvexchmbx1.microsemi.net>
References: <1487847303-82580-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D194F331B4F@avsrvexchmbx1.microsemi.net>
 <af59c314-358c-0dba-722f-c582eabf1092@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0084.outbound.protection.outlook.com ([104.47.40.84]:11088
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756368AbdCGXTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Mar 2017 18:19:32 -0500
In-Reply-To: <af59c314-358c-0dba-722f-c582eabf1092@suse.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.com]
> Sent: Tuesday, March 07, 2017 9:25 AM
> To: Don Brace <don.brace@microsemi.com>; Hannes Reinecke
> <hare@suse.de>; Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org
> Subject: Re: [PATCHv2] hpsa: expose enclosures
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 03/07/2017 04:05 PM, Don Brace wrote:
> >> -----Original Message-----
> >> From: Hannes Reinecke [mailto:hare@suse.de]
> >> Sent: Thursday, February 23, 2017 4:55 AM
> >> To: Martin K. Petersen <martin.petersen@oracle.com>
> >> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> >> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> >> Hannes Reinecke <hare@suse.de>; Don Brace
> >> <don.brace@microsemi.com>; Hannes Reinecke <hare@suse.com>
> >> Subject: [PATCHv2] hpsa: expose enclosures
> >>
> >> EXTERNAL EMAIL
> >>
> >>
> >> Some servers have a built-in enclosure which will show up on the
> >> same bus as the internal physical devices. This patch fixes the
> >> driver to expose them.
> >>
> >> Cc: Don Brace <don.brace@microsemi.com>
> >> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >
> > Masking various SES targets is a conscious choice, not a design oversig=
ht.
> > So, I have to decline this patch.,
> >
> Would you be okay with a module parameter for this?
> It really feels stupid to present the user with an enclosure device
> during boot (as hpsa presents all physical LUNs during booting), but not
> exporting it to the user.
>=20
> Cheers,
>=20
> Hannes

We would not be able to support this as it can cause issues with=20
LED management. A customer could pull the wrong drive and lose data because=
 the LED state was incorrect.
That results in support issues.

We like to show the enclosures even if masked as it helps with diagnosing p=
roblems.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation





> --
> Dr. Hannes Reinecke                            zSeries & Storage
> hare@suse.com                                  +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
