From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Sat, 08 Mar 2008 12:18:03 -0500
Message-ID: <47D2CA4B.5010804@tmr.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com> <1204843956.2673.8.camel@vema.umeoce.maine.edu> <200803072239.m27MdGVv028621@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:32884 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYCHRN3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 12:13:29 -0500
In-Reply-To: <200803072239.m27MdGVv028621@colby.verdasys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: Steve Cousins <steve.cousins@maine.edu>, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org

Marc Bejarano wrote:
> At 17:52 3/6/2008, Steve Cousins wrote:
> >Have you run any memory tests on the machine?
>
> no, but my suspicions lay elsewhere.  could bad memory explain the 
> right bits ending up in the wrong place on only one half of a mirror?

Yes. Memory problems can do almost anything, including making writes of 
some values to a disk controller behave differently than others.

While we don't have a good memory test for the "under load" case, 
memtest86 will at least identify some of the more common (read that as 
"most likely") failure types. Seeing no problems doesn't mean you don't 
have some, but not running the test means you haven't picked the 
low-hanging fruit.

I'm with Steve, bizarre problems deserve a memory test absent any clear 
pointers elsewhere.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


