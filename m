From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Wed, 19 Jun 2002 10:55:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0206191054400.58394-100000@beppo>
References: <20020619134436.A27002@devserv.devel.redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020619134436.A27002@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dledford@redhat.com, linux-scsi@vger.kernel.org


> 
> I think this is not enough, or backwards. We hit a situation with
> EMC when attaching hundreds of disks depleted atomic memory with
> queue request arrays before swapper had a chance to replenish it.
> I would much appreciate if the initial allocation was concervative,
> if low performing, and was adjusted upwards at slave_attach time.
> 
> For 2.5 I would appreciate if we made some SCSI allocations non-atomic.
> The probe time things better be GFP_KERNEL.

I'd go further and say that you only need probe your boot device. After that,
GFP_KERNEL is more than sufficient for anything.


