From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] Re: [PATCH RFC 0/4] use scatter lists for all block pc requests and simplify hw handlers
Date: Tue, 7 Jun 2005 09:01:58 +0200
Message-ID: <20050607070158.GX27119@marowsky-bree.de>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave> <1117955727.4961.8.camel@mina> <1117964506.15294.130.camel@zezette> <20050606133135.GZ27119@marowsky-bree.de> <1118102649.42a4e479b5d0f@webmail.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:10733 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S261813AbVFGJNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2005 05:13:33 -0400
Content-Disposition: inline
In-Reply-To: <1118102649.42a4e479b5d0f@webmail.cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 2005-06-06T19:04:09, Michael Christie <michaelc@cs.wisc.edu> wrote:

> > It's on the TODO list. It's just not done yet. Essentially we need
> > to be able to set BW_RW_FAILFAST from user-space for SGIO.
> >=20
> Isn't this a seperate issue? It looks like the RHAT bugzilla asks to
> be able to insert directly at the head of the queue so you do you not
> have to wait for possibly a hundred IO to complete before the test IO=
=2E
> Setting failfast just means in case of en error it will be returned
> faster (no wasting time retying).

Uhm, sorry, you're right. We actually want/need to be able to set both,
but it would sort of end up being the same mechanism (additional flags
to SGIO) and so I have it mentally lumped together ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
