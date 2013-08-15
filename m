From: Bud Brown <bud.brown@redhat.com>
Subject: Re: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600
Date: Thu, 15 Aug 2013 16:11:23 -0400 (EDT)
Message-ID: <1880433774.1915144.1376597483053.JavaMail.root@redhat.com>
References: <20130814205236.GB23042@beardog.cce.hp.com> <1376515627.2028.41.camel@dabdike.int.hansenpartnership.com> <48275AD710FCA34184C2B6186B4016B32735BD62@G6W2491.americas.hpqcorp.net> <520CB9C7.30307@redhat.com>
Reply-To: Bud Brown <bud.brown@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <520CB9C7.30307@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "Mike Miller (OS Dev)" <Mike.Miller@hp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, mikem@thumper.usa.hp.com, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org


> 
> >
> > James
> >
> > The patch origin is unknown. I got it from Tomas and Bud who think it may
> > have originated from HP. I cleaned it up, compile tested it, and sent it
> > on. I'll review my procedures for future patches.
> >
> > -- mikem
> >

Patch originated from me, although Tomas did the heavy lifting via kernel bisect
to localize the specific set of changes causing the performance regression.
Its modeled on the other P600'ism in the driver.

bud
