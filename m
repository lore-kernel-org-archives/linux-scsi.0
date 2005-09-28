From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: I request inclusion of SAS Transport Layer and AIC-94xx into
	 the kernel
Date: Wed, 28 Sep 2005 09:15:41 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C04388439@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751052AbVI1PP4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ltuikov@yahoo.com, Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday, September 28, 2005 5:42 AM, Luben Tuikov wrote:
> > Hi Luben,
> > 
> > OK, Man are you alright?
> > 
> > I've heard of other vendors planning to 
> > provide solutions where sas is implemented
> > in firmware, similar to MPT.  Christophs
> > sas layer is going to work with other 
> > solutions, don't think of it being 
> > MPT centric.
> 
> Where in what I said above do I say that it will _not_
> work with _other_ MPT based drivers?  Nowhere!
> 
> Yes it _will_ work with other MPT-like drivers but
> to cut and paste again from above:
>  * MPT based only,
>  * doesn't follow a spec to save its life,
>  * far inferior in SAS capabilities and SAS representation
>    again, due to the fact that it is MPT based.
> 
> When I say MPT, I do not mean MPT(R), I mean MPT as
> in technology, not as in trademark.
> 
>      Luben
> 

Luben: I guess you didn't get what I meant.

I was referring that there are other
*vendors* (not LSI, e.g MegaRAID) that are 
working on sas solutions with sas firmware 
implementation. One that comes to mind is
Intel SunRise Lake, which is non a MPT based 
solution, that would work with Christophs 
Sas Layer. There maybe others, such as emulex.
Perhaps James S. could comment on that.

Eric
