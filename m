From: Stephen Harker <sjh@adfa.edu.au>
Subject: Re: PROBLEM: module a100u2w (SCSI, Initio) on ppc
Date: Sun, 9 Nov 2008 15:13:39 +1100
Message-ID: <20081109041339.GA6188@h42148.pems.adfa.edu.au>
References: <20080712033040.GA8086@h42136.pems.adfa.edu.au> <20080711220901.e1b69adb.akpm@linux-foundation.org> <20080715233044N.fujita.tomonori@lab.ntt.co.jp>
Reply-To: Stephen Harker <s.harker@adfa.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.adfa.edu.au ([131.236.200.17]:6538 "EHLO mx2.adfa.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbYKIEZZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2008 23:25:25 -0500
Content-Disposition: inline
In-Reply-To: <20080715233044N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: s.harker@adfa.edu.au, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 15, 2008 at 11:30:27PM +0900, FUJITA Tomonori wrote:
> On Fri, 11 Jul 2008 22:09:01 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > (cc linux-scsi)
> > 
> > On Sat, 12 Jul 2008 13:30:41 +1000 Stephen Harker <s.harker@adfa.edu.au> wrote:
> [...]
> Seems that this driver has some bugs on big endian architectures
> (though I've not looked at the patch):
> 
> http://marc.info/?l=linux-scsi&m=121613124207253&w=2

I realised I had not replied to this email.  With this patch the
driver works fine.  I now have both drives on the Initio SCSI bus and
am running Linux (Yellow Dog), OSX and OS9 with no problems.  A rough
timing attempt (hdparm -t) gave something like 18 MB/sec for the IBM
UltraStar and around 35 MB/sec for the Cheetah.  This is a big
improvement over the built in MESH with its limit of 10 MB/sec!

-- 
Stephen Harker                           s.harker@adfa.edu.au
PEMS
UNSW@ADFA
