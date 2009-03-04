From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 07:39:25 +0100
Message-ID: <49AE221D.9010909@s5r6.in-berlin.de>
References: <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60017 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZCDGkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 01:40:03 -0500
In-Reply-To: <20090303234834.GA13389@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Perhaps you could avoid putting such fixes into published 
>> merge branches.
[so that consumers of the trees use them only on demand]
> 
> Yeah, these commits are in none of the topic branches that are 
> the git base of development, they are all already in a separate 
> branch named "tip:out-of-tree".

So people should remember to retry without out-of-tree before reporting
problems == remember to report against the development base.

> That separate branch carries 
> assorted fixlets for various bugs we trigger in -tip qa. It 
> never goes upstream-wards, obviously. It's a bit like the 
> fixlets portion of -mm.

Great, if an eye is kept on issues & resolutions tracking --- like in
this thread, only with less confusion. ;-)
-- 
Stefan Richter
-=====-==--= --== --=--
http://arcgraph.de/sr/
