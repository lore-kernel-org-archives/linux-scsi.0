From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH] hpsa: do not re-order commands in internal queues
Date: Tue, 11 Jan 2011 14:52:11 -0800 (PST)
Message-ID: <877909.84984.qm@web33006.mail.mud.yahoo.com>
References: <20110111224658.24457.62925.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110111224658.24457.62925.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org



--- On Tue, 1/11/11, Stephen M. Cameron <scameron@beardog.cce.hp.com> w=
rote:

[...]
> @@ -2837,8 +2837,8 @@ static void start_io(struct ctlr_info
> *h)
>  {
>  =A0=A0=A0 struct CommandList *c;
> =20
> -=A0=A0=A0 while (!hlist_empty(&h->reqQ))
> {
> -=A0=A0=A0 =A0=A0=A0 c =3D
> hlist_entry(h->reqQ.first, struct CommandList, list);
> +=A0=A0=A0 while (!list_empty(&h->reqQ)) {
> +=A0=A0=A0 =A0=A0=A0 c =3D
> list_entry(h->reqQ.first, struct CommandList, list);


No, I screwed this up.  Disregard this patch.

-- steve




     =20
