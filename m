From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH RFC] increase ST_MAX_TAPES from 128 to 1024
Date: Fri, 17 Aug 2012 11:19:10 -0400
Message-ID: <502E60EE.6010009@suse.com>
References: <1345215024-5883-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab2HQPTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Aug 2012 11:19:16 -0400
In-Reply-To: <1345215024-5883-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: Kai.Makisara@kolumbus.fi, lduncan@suse.com, linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/17/12 10:50 AM, Rob Evers wrote:
> Wondering if this would be an acceptable interim solution to
> increasing the limit on the number of tape drives while
> http://marc.info/?l=linux-scsi&m=134212042809524&w=2 gets sorted
> out.

I have the updated patch that fixes the tape symlink problem. I'll
send it out in a few.

- -Jeff

> Signed-off-by: Rob Evers <revers@redhat.com> --- drivers/scsi/st.h
> | 2 +- 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h index
> b548923..408d24f 100644 --- a/drivers/scsi/st.h +++
> b/drivers/scsi/st.h @@ -76,7 +76,7 @@ struct st_modedef { #define
> ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS) #define ST_MODE_MASK
> ((ST_NBR_MODES - 1) << ST_MODE_SHIFT)
> 
> -#define ST_MAX_TAPES 128 +#define ST_MAX_TAPES 1024 #define
> ST_MAX_TAPE_ENTRIES  (ST_MAX_TAPES << (ST_NBR_MODE_BITS + 1))
> 
> /* The status related to each partition */
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQLmDuAAoJEB57S2MheeWy+88QAIVVF/Mu8lZ84WPQhn5TXrae
KOcJJD6uk7trtJ9sFclQXrBZtD6lu4ZXbic6/OoVFlOVkDO7xT9xTGVQkJKg2moC
RcQNQ7CeXMSdvVNY4pSaNHr6Fi2qkxXZVDA4RKyBZFhA9WRAk/WIYieUbI65wgGR
irVHZwTN7xVB4HyFQxUuuOFAfdzDfGgKu5J8MmpLyarDSAsRtxcPyTTTtkmAHl4I
yBzHZ+6Un8GVvLnmK1vY5ITQs6Z83l/hkoPp9KOJp4qKFBqZkV2NOLjrJn9sgbKO
VhF0ZV2bsgUykRABaY34f2/ku7IS4B4W+gMpDf80nxQoY1L8FhphrNGDXW6PzgXI
BVxkrsbszs+VeGYmVzLW2xoG67HKTaB0LxaKP2owx8hOySm6E1qTQBGy88Q3+Yky
nx839CdVLrlNTG/VaVIGR3q1ZU2ODyOCXf5Z9XUUmCJJxfvOYjEmjBMBu0ITvlqL
L/WrPHNuZ/6Kp94VouZoNviQ2GsC9+8wFWc1Ypnx1OLGEj3dk9z792U9IiDGGb0I
49Dh7g4+aySGWUDVLzOmAEcv+um3efzljKpQH4mfLmqhOi01lXg8Hk2cRsU8roiO
BUBoWCUsTVcWkq54Hbl6HeGgGBRhZ/WYxhwc7UVOofwlmuO6aKsgB8hnadf/AkRx
SQhOzzdr2FVDse4ujHyz
=yseB
-----END PGP SIGNATURE-----
