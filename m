From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Tue, 6 Apr 2004 10:47:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F291@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:62349 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263840AbUDFOr1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 10:47:27 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
> On Tue, Apr 06, 2004 at 10:03:58AM -0400, Salyzyn, Mark wrote:
>> OEMs and their users are virtually *all* we are concerned about. If
>> we can not qualify our products within their needs, we disappear, or
>> at least we disappear on operating systems that fail to provide for
>> the needs of the users.
>Well, bad luck for adaptec then.  It's not like there aren't other RAID
HBA
>vendors.

Remember DPT? Thanks for all the Fish ...

These competitors have the same problem !!!

The failure is not bad luck for the storage vendors, but bad luck for
the users and those that think Linux can survive without users. I
represent the users, not Storage Vendors.

>> I loose sleep at night thinking about these poor souls. No, to be
>> honest, actually it is because our OEM's test group thinks out
>> fantastic scenarios of ways to break yours and my products and hold
>> us accountable for such failures. "Deleting array causes kernel
>> ooops" news at 11 ...
>Again, where do you see that oops?  if I remove the lun under a
>filesystem that one spews EIO all over and becomes unusable.  But if
>you get a panic that's a bug in the filesystem driver.

Ooops, system lockup, system unusable, panic, dogs and cats sleeping
with eachother; it doesn't matter the semantics of the failure. The bug
is that the OS provided no means to avert the disaster. One of the major
precepts of user interface design is the ability to predict what a
specific action will take when taken. The OS is not predictable in this
case, and as such can not end up earning our trust.

An untrusted OS is an unused OS.

>> Which reason do we ascribe to this failure of the operating system to
provide the service of knowing if a drive is currently in-use:
>> 
>> 1) system has been architected in such a manner that it would be
impossible at this juncture to add?
>> 2) Someone made a conscientious decision to not provide this
functionality?
>> 3) There is a way to tell, it just is not clear to any of us at this
moment?
>> 4) There is a way to tell, but it would be an ugly hack that will no
doubt break upon the next revision (as this hack has done traversing
from 2.4 to 2.6)?
>> 5) Pride?
>There is a way to tell whether it's inuse, but it's a different
definition
>of inuse than you want, and it's not a public interface so it could
break
>all the time.  Probably as soon as some out of tree driver gets the
bright
>idea to use it inspite everyone telling them not to.

BTW, name calling like `out of tree driver' had me rotfl. I would like
to point out that the dpt_i2o driver is currently unusable in the tree
and is disabled. The only driver that works is the one I provide to the
community for the asking ...

Ok, so it is a mix of #1 (because it can not be fixed reliably) and #4
(we hate hacks around system deficiencies). Are you sure we can not
provide a reliable defined interface for this service?

Sincerely -- Mark Salyzyn

