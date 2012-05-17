From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [patch] iscsi-target: remove some dead code
Date: Thu, 17 May 2012 11:15:13 -0400
Message-ID: <20120517151513.GD17575@logfs.org>
References: <20120517070814.GD14660@elgon.mountain>
 <4FB4CBD0.8000503@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60915 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2EQRUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 13:20:18 -0400
Content-Disposition: inline
In-Reply-To: <4FB4CBD0.8000503@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Jesper Juhl <jj@chaosbits.net>, Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 17 May 2012 11:58:40 +0200, walter harms wrote:
>=20
> the changes look reasonable but to be fair the code should have an ex=
planation
> what it is supposed to do. I do not have the feeling that i did under=
stand the
> purpose completely.

I suppose that is a decent summary for much of the target code.
Patches are clearly welcome.

J=C3=B6rn

--
=46ancy algorithms are buggier than simple ones, and they're much harde=
r
to implement. Use simple algorithms as well as simple data structures.
-- Rob Pike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
