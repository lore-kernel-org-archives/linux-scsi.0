From: John Cherry <cherry@osdl.org>
Subject: Re: [PATCH] aic7xxx parallel build
Date: Thu, 22 Jan 2004 16:54:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074819272.15610.2.camel@cherrypit.pdx.osdl.net>
References: <1074800332.29125.55.camel@cherrypit.pdx.osdl.net>
	 <1251588112.1074819190@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:19330 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265148AbUAWAyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 19:54:36 -0500
In-Reply-To: <1251588112.1074819190@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: akpm@osdl.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org

Yeah.  It looks like I grabbed my old patch from the last successful
parallel build that Andrew ran.

I'll run the regressions on the Makefiles you have supplied tonight.  I
have no doubts that this will be successful.  Thanks.

John

On Thu, 2004-01-22 at 16:53, Justin T. Gibbs wrote:
> > The Makefiles for aic7xxx and aicasm have changed since I submitted a
> > patch for the parallel build problem several months ago.  Justin's patch
> > has disappeared from the mm builds, so we continue to have parallel
> > build problems.
> > 
> > The following patch fixes the parallel build problem and it still
> > applies to 2.6.2-rc1-mm1.  This is Justin's fix.
> 
> Actually, that's not my fix.  This looks like your original fix.
> I've attached aic7xxx/Makefile and aic7xxx/aicasm/Makefile from my
> tree.  These seem to work just fine in my parallel build tests and
> will work regardless of which generated file is out of date - a flaw
> in your change.  Please let me know if these files don't work for you.
> 
> --
> Justin

