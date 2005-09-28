From: Luben Tuikov <ltuikov@yahoo.com>
Subject: RE: I request inclusion of SAS Transport Layer and AIC-94xx into  the kernel
Date: Wed, 28 Sep 2005 04:42:28 -0700 (PDT)
Message-ID: <20050928114228.13609.qmail@web31802.mail.mud.yahoo.com>
References: <91888D455306F94EBD4D168954A9457C0438823C@nacos172.co.lsil.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750885AbVI1Lma@vger.kernel.org>
In-Reply-To: <91888D455306F94EBD4D168954A9457C0438823C@nacos172.co.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--- "Moore, Eric Dean" <Eric.Moore@lsil.com> wrote:

> On Tuesday, September 27, 2005 4:51 PM, Luben Tuikov wrote:
> 
> > Christoph's code is
> >  * MPT based only,
> >  * doesn't follow a spec to save its life,
> >  * far inferior in SAS capabilities and SAS representation
> >    again, due to the fact that it is MPT based.
> > 
> > Since the whole point of MPT is to _hide_ the transport.
> > 
> 
> 
> Hi Luben,
> 
> OK, Man are you alright?
> 
> I've heard of other vendors planning to 
> provide solutions where sas is implemented
> in firmware, similar to MPT.  Christophs
> sas layer is going to work with other 
> solutions, don't think of it being 
> MPT centric.

Where in what I said above do I say that it will _not_
work with _other_ MPT based drivers?  Nowhere!

Yes it _will_ work with other MPT-like drivers but
to cut and paste again from above:
 * MPT based only,
 * doesn't follow a spec to save its life,
 * far inferior in SAS capabilities and SAS representation
   again, due to the fact that it is MPT based.

When I say MPT, I do not mean MPT(R), I mean MPT as
in technology, not as in trademark.

     Luben
