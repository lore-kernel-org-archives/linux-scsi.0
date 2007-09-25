From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 6/9] mpt fusion: error recovery improvements, andsynchronizing internal commands
Date: Mon, 24 Sep 2007 19:35:42 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709D92A7@NAMAIL4.ad.lsil.com>
References: <1190476911.3347.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35871 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbXIYBft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 21:35:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1190476911.3347.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Saturday, September 22, 2007 10:02 AM, James Bottomley  wrote: 

> What fixes?
> 
> The object of a change log is to preserve the history of a particular
> change (as per the Developer Certificate of Origin).  This 
> means if you
> get a patch from someone, you should also collect their 
> signoff with it,
> then you pass it on to me complete with your signoff added (and a note
> if you had to modify it to fit it into the patch series or otherwise
> alter it).
> 
> James
> 
> 
> 

James, Mike sent me an email back on June 13, contain 11 suggested
changes associated with his test efforts with my new code having rewrote
internal command error handling, and adding new polling function for
controller fault handling.   The changes he quoted associated to the
ones in mptfc seem vague.  I have the email I could forward, but at that
time, It probably doesnt matter.

Eric
