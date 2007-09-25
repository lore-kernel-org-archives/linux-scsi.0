From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 6/9] mpt fusion: error recovery improvements,
	andsynchronizing internal commands
Date: Tue, 25 Sep 2007 12:35:50 -0500
Message-ID: <1190741750.3345.32.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D709D92A7@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60578 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757042AbXIYRfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 13:35:51 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D709D92A7@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-09-24 at 19:35 -0600, Moore, Eric wrote:
> On Saturday, September 22, 2007 10:02 AM, James Bottomley  wrote: 
> 
> > What fixes?
> > 
> > The object of a change log is to preserve the history of a particular
> > change (as per the Developer Certificate of Origin).  This 
> > means if you
> > get a patch from someone, you should also collect their 
> > signoff with it,
> > then you pass it on to me complete with your signoff added (and a note
> > if you had to modify it to fit it into the patch series or otherwise
> > alter it).
> > 
> > James
> > 
> > 
> > 
> 
> James, Mike sent me an email back on June 13, contain 11 suggested
> changes associated with his test efforts with my new code having rewrote
> internal command error handling, and adding new polling function for
> controller fault handling.   The changes he quoted associated to the
> ones in mptfc seem vague.  I have the email I could forward, but at that
> time, It probably doesnt matter.

I just need a description that says what the patch is doing.  Fixes
provided by SGI isn't descriptive enough.

James


