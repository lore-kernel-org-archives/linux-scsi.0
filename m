From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 2.4.25-pre8: loss of SCSI I/O initiative
Date: Mon, 02 Feb 2004 13:48:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075747729.3248.17.camel@compaq.xsintricity.com>
References: <OFA5E0980A.777ADFCB-ONC1256E2C.00131EB3-C1256E2E.0061B28C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:23175 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265768AbUBBSsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2004 13:48:54 -0500
In-Reply-To: <OFA5E0980A.777ADFCB-ONC1256E2C.00131EB3-C1256E2E.0061B28C@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, andmike@us.ibm.com, axboe@suse.de, garloff@suse.de

On Mon, 2004-02-02 at 12:42, Martin Peschke3 wrote:
> 
> 
> Marcelo, Doug,
> 
> here is another patch, which corrects some 'loss of initiative' problems.

Hi Martin.  Both of the patches you posted touch areas of code that are
also touched by some of the patches I'm merging for the everything
tree.  So, Marcelo, whether or not to take these depends partially on
your decision as to what to do with the other scsi patches we've got
here and that SuSE has.  In particular, it's possible that the mlqueue
patch that I haven't got in my 2.4-everything tree yet may very well
obsolete the need for one of these, and another patch in our tree may
obsolete the need for the other.  I'm not sure yet.  Anyway, just wanted
to let you know that if you are considering the bigger set of SCSI
patches (and yes, I'm sure you want to see them before you would ever
say yes, I'm just not sure if you've already decided that your answer is
"no") then both of these patches from Martin would have to be merged
with the final product and might not be necessary in the end, or if they
are necessary I'm sure they'll have a slightly different form.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


