From: Michael Tokarev <mjt+iscsi@tls.msk.ru>
Subject: Re: [RFC] [PATCH 0/7] requested for qla4xxx!!!
Date: Wed, 05 Jul 2006 23:06:44 +0400
Message-ID: <44AC0DC4.2030606@tls.msk.ru>
References: <20060629064812.GA7220@ranandlinuxbox.oc.cox.net> <44A6CCBC.7000603@tls.msk.ru> <44ABF71F.4060206@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:31574 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S964989AbWGETGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2006 15:06:49 -0400
In-Reply-To: <44ABF71F.4060206@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Michael Tokarev wrote:
[]
[]
>> I've tried against curren open-iscsi svn repo, against
>> scsi-misc kernel git tree, and against open-iscsi-1.0-485
>> tarball.  Whch all are mostly similar (in API anyway).
>> ql4 driver does not compile - even after "fixing" some
>> "missing" #includes (like iscsi_if.h defining most of
>> the ISCSI_* constants used in ql4_os.c), there are alot
>> of functions missing (iscsi_{add,remove,free}_session()
>> etc), undeclared structures used (*dscvr*) etc.
> 
> For the kernel code you need to get the scsi-misc tree (see
> kernel.org/git for details). For the userspace tools you need the
> open-iscsi.org svn tree with this patch
> 
> http://www.cs.wisc.edu/~michaelc/iscsi/open-iscsi/linux-scsi/tmp-qla4xxx-hook-into-userpace3.patch

Aha!  Here we go: that's the missing decls.
As I mentioned (above), I've already tried scsi-misc tree, and
open-iscsi svn - the patch above "fixes" the rest of the probs
during compilation (after fixing obvious probs in ql4xx sources).
Ok, that's.. umm.. not obvious at all that the patch above is
needed, and where to find it ;)



> For the userspace tools, we do not have the init scripts finished up so
> you have to build the svn userspace tools, install them, then run

That's no problem at all.  But thanks (or maybe not? -- you save me from
reading the docs (aka "RTFM"), which might be not that bad really - I mean,
reading them sometimes helps ;)

Building the modules and tools now...  Thanks for the pointers and the
explanation!

/mjt

