From: Paul Wagland <paul@wagland.net>
Subject: Re: reiser4 and megaraid problems with debian 2.6.5
Date: Wed, 14 Apr 2004 17:37:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <9D26AED2-8E29-11D8-A41D-000A95CD704C@wagland.net>
References: <36927C82-8DE0-11D8-A41D-000A95CD704C@wagland.net> <407D550D.5030003@namesys.com>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-44-570623825"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out4.xs4all.nl ([194.109.24.5]:23303 "EHLO
	smtp-out4.xs4all.nl") by vger.kernel.org with ESMTP id S263716AbUDNPh0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2004 11:37:26 -0400
In-Reply-To: <407D550D.5030003@namesys.com>
List-Id: linux-scsi@vger.kernel.org
To: Hans Reiser <reiser@namesys.com>
Cc: Linux mailing list SCSI <linux-scsi@vger.kernel.org>, Linux mailing list kernel <linux-kernel@vger.kernel.org>


--Apple-Mail-44-570623825
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Apr 14, 2004, at 17:13, Hans Reiser wrote:

> Paul Wagland wrote:
>
>> I am using the debian prepared kernel with the debian reiser4 patch. 
>> I made a cursory examination of the patch, and it appears to 
>> correlate fairly closely with the patch from the namesys site.
>
> In what way does it not correlate?

As was mentioned by Domenico Andreoli the changes are just those 
required to get reiser4 to work under 2.6.5. Other differences are line 
offsets due to the fact that the debian kernel also has patches 
applied.

>> If I can help debug this situation (I am probably the only person 
>> trying this combination :-) please let me know how I should go about 
>> it.
>
> I don't have the hardware to test it, can you get the error without 
> your hardware?

Unfortunately, not easily, since this is the only box that I can 
currently test this out on. However, there a couple of tests that I can 
still perform (as mentioned elsewhere in this thread) and I will report 
back on the results of those later tonight.

Cheers,
Paul

--Apple-Mail-44-570623825
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFAfVqxtch0EvEFvxURAunMAJwJMw+cQmxTIkFW6yTHB+mic3UdCQCeKQnQ
xJg4mdKAcNVwCc9EGggNLEs=
=5+Ui
-----END PGP SIGNATURE-----

--Apple-Mail-44-570623825--

