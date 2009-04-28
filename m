From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 13143] scsi_debug doesn't manage more than 1Tb
Date: Tue, 28 Apr 2009 17:31:59 +0900
Message-ID: <20090428173230U.fujita.tomonori@lab.ntt.co.jp>
References: <bug-13143-11613@http.bugzilla.kernel.org/>
	<200904271041.n3RAf0XT000556@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55230 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZD1IcD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2009 04:32:03 -0400
In-Reply-To: <200904271041.n3RAf0XT000556@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Mon, 27 Apr 2009 10:41:00 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13143
> 
> 
> 
> 
> 
> --- Comment #4 from Thierry Vignaud <tvignaud@mandriva.com>  2009-04-27 10:39:15 ---
> (In reply to comment #1)
> > it seems invalid that you tested linux 2.5 ?
> 
> Version was auto filled by bugzilla. Really was 2.6.29.1
> 
> > And could you describe it more detailed as in REPORTING-BUGS ?
> 
> All needed data was provided in initial comment. And it was enough in order to
> provide a fix.

The patch is available:

http://marc.info/?l=linux-scsi&m=124063464410711&w=2


Can you confirm that it fixes the problem?
