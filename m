From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 15:45:27 +0100
Message-ID: <20081107144527.GA32092@logfs.org>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107143425.GE15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:48625 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYKGOqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 09:46:05 -0500
Content-Disposition: inline
In-Reply-To: <20081107143425.GE15439@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>

On Fri, 7 November 2008 07:34:26 -0700, Matthew Wilcox wrote:
>=20
> It's the opposite of a _flash_ friendly policy.  But SSDs are not nai=
ve
> flash implementations -- if you overwrite a block, it'll just write
> elsewhere and update its internal mapping of LBAs to sectors.  I

Note that for many of the *cough* cheaper implementations, "elsewhere"
is still very close to the specified address.

J=C3=B6rn

--=20
When people work hard for you for a pat on the back, you've got
to give them that pat.
-- Robert Heinlein
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
