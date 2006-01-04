From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] dont decrement counters from scsi_kill_request
Date: Wed, 4 Jan 2006 09:13:36 +0100
Message-ID: <200601040913.42413@bilbo.math.uni-mannheim.de>
References: <1136360688.9634.2.camel@max> <200601040852.15700@bilbo.math.uni-mannheim.de> <20060104080518.GO27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1745728.9lvsPRFP40";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:33497 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751589AbWADINp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 03:13:45 -0500
In-Reply-To: <20060104080518.GO27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

--nextPart1745728.9lvsPRFP40
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Al Viro wrote:
>On Wed, Jan 04, 2006 at 08:51:57AM +0100, Rolf Eike Beer wrote:
>> Mike Christie wrote:
>> >+	while (end_that_request_first(req, 0, req->nr_sectors))
>> >+		;
>>
>> This should be something like
>>
>> while (...)
>> 	{}
>>
>> so it is absolutely clear that the empty body is intentional.
>
>Please, do not inflict that ugliness on everyone.  FWIW, it's less
>idiomatic than normal use of ; and personally I'd parse it as "somebody
>had fscked up using editor", not as "wow, they _really_ meant it to be
>an empty body".

Using only ; on a single line looks like some code left over from removing=
=20
code... Ok, so let's agree to disagree. Since coding style says the opening=
=20
brace should be on the same line as the while, would it be better to put=20
everthing in one line to make clear what's going on?

Eike

--nextPart1745728.9lvsPRFP40
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDu4O2XKSJPmm5/E4RAuWyAJ9sQj4bhWiLg4YkgAlVojAno8gNDQCcCDYh
7hEiFloEuArWbUK+m/bH/SM=
=kqDC
-----END PGP SIGNATURE-----

--nextPart1745728.9lvsPRFP40--
