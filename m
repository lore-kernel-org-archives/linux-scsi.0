From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 15:21:14 -0600
Message-ID: <511D554A.2090100@tributary.com>
References: <1360767971-947-1-git-send-email-hare@suse.de> <1360813027.2502.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:47477 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab3BNVVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 16:21:16 -0500
In-Reply-To: <1360813027.2502.7.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2013 9:37 PM, James Bottomley wrote:

> What advantage does this have over setting max_lun to ~0?

	Is it possible the adapters have LUN resource limits as well as ID limits? In
those cases it would be nice to notify the user that LUNs exist, but are not
addressable with the given hba. Of course ignoring the address mode bits keeps
this from working properly as the max_lun needs to be set much larger than the
actual supported lun limit.




	


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRHVVKAAoJEL5i86xrzcy7zCQIAJzMmQbVb6yFDEv3od16xVI3
DN8ZzscwJQcreJfIpyoBPk4d0gjfCXO1Cc/PeMQegNwgc4TmfoLHXj1/61irATjv
GH+xGiJCMxcLX1eIF5D3JC8cleXa+A1YD5ayKeIkYsHSK4S5kPovmS5gzvgJlhPE
N5oToRe5RQda0nAeiV0VMPKuxANud2ZC6N61ncMHAn1wLeI7gq2JBtvZi3NXAfub
IRacak9LN9QLrlrZh6YQdA8RK9LVGHJwCYahBUG1MYH0ceTyoj15BOPLT/El3ET5
6CSpi7a/TMufwpWtLJp4YzVUU2tIvFxIusTbrzMy0ioYSWD9J7Egangs5ue48Xg=
=yyk0
-----END PGP SIGNATURE-----
