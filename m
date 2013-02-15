From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Fri, 15 Feb 2013 10:25:18 -0600
Message-ID: <511E616E.6040100@tributary.com>
References: <1360767971-947-1-git-send-email-hare@suse.de> <1360813027.2502.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:41018 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab3BOQZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 11:25:25 -0500
In-Reply-To: <1360813027.2502.7.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2013 9:37 PM, James Bottomley wrote:

> What advantage does this have over setting max_lun to ~0?


	Actually, after having all those other discussions. I've come to see the
elegance in this suggestion.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRHmFuAAoJEL5i86xrzcy7RXkH+QHeQeWZE4Z5Qe2GcKj64SVV
eqnQNiOoOR4sKmPM1J8AhBbOj/sl6upSSXrHgcK9EGKCA8R099wwdYjFhyLy+RQn
HZURfpJbxEWItGJd9mouGqR6SeUiifs7If9VUp+/OJXiBtePD8Vu3GQB0p7v0DwI
BlKkUTnMAQgYPYPc8iMJiGJYf38ZtMJFU0oHow5L0VZG6zTJhxcOmAxEuu1zqJWX
5hvSw0jgXmAJ/p798LWKw4FjhdBFAyG1BcK8RmEsHqoW4XecSHU6qXvxokiVgIMt
QKMuCHTRjxzVQCkpyUUc3hEH24kZFU8PqeMPw46dFYndZrM9Jg/3zq74k6aZlJo=
=wwUR
-----END PGP SIGNATURE-----
