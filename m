From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] 2.4.25-pre8: loss of SCSI I/O initiative
Date: Mon, 2 Feb 2004 21:42:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF9F0423F.7530357E-ONC1256E2E.0068FBE8-C1256E2E.0072346F@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:8142 "EHLO
	mtagate7.de.ibm.com") by vger.kernel.org with ESMTP id S265973AbUBBUmx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2004 15:42:53 -0500
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, andmike@us.ibm.com, axboe@suse.de, garloff@suse.de





Doug,

I have just checked the latest RedHat EL kernel sources and found
some related changes. Nonetheless, the SCSI DMA pool fix seems to be
needed in RedHat Linux as well. IMO, the 'pure fixes' tree is a better
place for these patches than the 'everything' tree.

Marcelo,

I'd certainly appriciate if the pile of patches being prepared by Doug
was merged into the kernel. It will be fine with me if it is his decisi=
on
whether the reported problems are to be solved by the patches I
posted or by Doug's other patches. I just want these problems
being taken care of in some way. I will not be too concerned
(that's your business ;-), if none of both fixes makes it into
2.4.25, but show up in some form in a later 2.4 kernel, as costumers
use distributors' back-level kernels anyway.

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Doug Ledford <dledford@redhat.com> on 02/02/2004 19:48:49

To:    Martin Peschke3/Germany/IBM@IBMDE
cc:    Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi maili=
ng
       list <linux-scsi@vger.kernel.org>, andmike@us.ibm.com,
       axboe@suse.de, garloff@suse.de
Subject:    Re: [PATCH] 2.4.25-pre8: loss of SCSI I/O initiative


On Mon, 2004-02-02 at 12:42, Martin Peschke3 wrote:
>
>
> Marcelo, Doug,
>
> here is another patch, which corrects some 'loss of initiative' probl=
ems.

Hi Martin.  Both of the patches you posted touch areas of code that are
also touched by some of the patches I'm merging for the everything
tree.  So, Marcelo, whether or not to take these depends partially on
your decision as to what to do with the other scsi patches we've got
here and that SuSE has.  In particular, it's possible that the mlqueue
patch that I haven't got in my 2.4-everything tree yet may very well
obsolete the need for one of these, and another patch in our tree may
obsolete the need for the other.  I'm not sure yet.  Anyway, just wante=
d
to let you know that if you are considering the bigger set of SCSI
patches (and yes, I'm sure you want to see them before you would ever
say yes, I'm just not sure if you've already decided that your answer i=
s
"no") then both of these patches from Martin would have to be merged
with the final product and might not be necessary in the end, or if the=
y
are necessary I'm sure they'll have a slightly different form.

--
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606





-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
