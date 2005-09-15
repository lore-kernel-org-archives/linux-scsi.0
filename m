From: Jack Byer <ojbyer@usa.net>
Subject: Re: Hardware RAID problem
Date: Thu, 15 Sep 2005 19:13:02 -0400
Message-ID: <4329FFFE.5020907@usa.net>
References: <dgcpuo$n6a$1@sea.gmane.org> <b1bc6a00050915152657ebb321@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp08552403pcs.groton01.ct.comcast.net ([69.138.132.253]:28897
	"EHLO copper.fuckthenavy.net") by vger.kernel.org with ESMTP
	id S1751147AbVIOXNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 19:13:13 -0400
In-Reply-To: <b1bc6a00050915152657ebb321@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aradford@gmail.com
Cc: linux-scsi@vger.kernel.org

adam radford wrote:
> Jack,
> 
> There was a bug in 3w-9xxx that became apparent with the latest scsi-block-2.6
> merge.  Can you re-test the 3ware 9000 with 2.6.14-rc1?
> 
> -Adam


The 3ware machine works with 2.6.14-rc1; still no luck with the Megaraid
machine.


> On 9/15/05, Jack Byer <ojbyer@usa.net> wrote:
> 
>>Last week, I reported a problem booting my machine with a AMI megaraid
>>card. This problem appeared on -mm kernels >= 2.6.12-mm1 and on
>>2.6.14-rc1. I tried applying a patch from Christoph Hellwig, which did
>>not resolve the problem.
>>
>>Now I am seeing the exact same bug on a different machine, using a
>>different raid controller (3ware 9xxx series) when trying to install
>>2.6.13-mm1.
>>
>>Is there any chance that this is a kernel configuration problem, or has
>>something recently changed in the scsi drivers that is affecting both
>>drivers?
>>
>>-
