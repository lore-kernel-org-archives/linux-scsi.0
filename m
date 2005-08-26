From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Process in D state with st driver
Date: Fri, 26 Aug 2005 19:41:20 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0508261940570.2960@kai.makisara.local>
References: <Pine.LNX.4.61.0508242214360.2982@kai.makisara.local>
 <20050824202921.GI3360@kiwi.hjbaader.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:63390 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S965102AbVHZQgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 12:36:35 -0400
In-Reply-To: <20050824202921.GI3360@kiwi.hjbaader.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans-Joachim Baader <hjb@pro-linux.de>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Wed, 24 Aug 2005, Hans-Joachim Baader wrote:

> Hi,
> 
> > This kind of a problem of a process using a tape hanging in D state has 
> > occurred sometimes for numerous years. When the user has waited long 
> > enough (the default timeouts are loooong), the process has continued. When 
> > st has printed the command timed out, it has been usually a legitimate 
> > read or write. St has sent the command and waited for it to finish but 
> > this has never occurred. These problems may or may not be related to the 
> > current one.
> > 
> > I have never been able to reproduce the problem in my systems.
> 
> Do you have a SMP system?
> 
I used to have an SMP system. Now I am using P4 HT with SMP kernel for 
testing. So, just having an SMP system should not cause this problem.

-- 
Kai
