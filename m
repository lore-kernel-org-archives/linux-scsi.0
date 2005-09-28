From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 	 the kernel
Date: Wed, 28 Sep 2005 12:59:27 -0400
Message-ID: <433ACBEF.9040006@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C04388439@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751304AbVI1Q7l@vger.kernel.org>
In-Reply-To: <91888D455306F94EBD4D168954A9457C04388439@nacos172.co.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/28/05 11:15, Moore, Eric Dean wrote:
> Luben: I guess you didn't get what I meant.
> 
> I was referring that there are other
> *vendors* (not LSI, e.g MegaRAID) that are 
> working on sas solutions with sas firmware 
> implementation. One that comes to mind is
> Intel SunRise Lake, which is non a MPT based 
> solution, that would work with Christophs 
> Sas Layer. There maybe others, such as emulex.
> Perhaps James S. could comment on that.

This means that they have an IOP on the same
silicone or on the same packaging.

This means, again that they'd done all transport
specific tasks in the FW (by the IOP).

Again, such solutions do _not_ need the
SAS Transport Layer.

They don't even need the attributes, but
as a "nice to have" feature, you can use
transport attributes.

You, as technical person, should recognize
the different needs and thus the different
solutions between LSI's implementation and
Adaptec's.

I'm surprised you never chimed in in defense
of the _different_ technology.

See, I've mentioned many times that the two
radically different technologies can coexist.
But I've not heard any technical word
from the other guys: you.

	Luben
