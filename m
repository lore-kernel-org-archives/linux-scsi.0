From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC]transient transport error report for LLD timeout
Date: Sat, 25 Sep 2004 20:28:30 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0409252026210.28582-100000@chimarrao.boston.redhat.com>
References: <200409232332.AA03619@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41697 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S269454AbUIZA2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 20:28:39 -0400
In-Reply-To: <200409232332.AA03619@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 24 Sep 2004, Masao Fukuchi wrote:

> We are now planning to use linux for enterprise system.
> In enterprise system, response time is important factor and it requires 
> response time within 30sec even if hardware(software) fails.

Makes some sense, I guess.  However it could lead to
spurious IO errors under high load since some disk
arrays are known to take longer than 10 seconds to
finish an IO operation under extremely heavy loads.

I'm not convinced that enterprise systems need latency
more than reliability, but maybe that's ust me ;)

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan

