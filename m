From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: Fw: [BUG] 2.6.17-rc1: SCSI kobject_add problems
Date: Mon, 24 Apr 2006 13:55:33 -0500 (CDT)
Message-ID: <20060424185533.6229EDBA1@gherkin.frus.com>
References: <444CE9A6.6030304@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:32270 "EHLO gherkin.frus.com")
	by vger.kernel.org with ESMTP id S1751123AbWDXSzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 14:55:35 -0400
In-Reply-To: <444CE9A6.6030304@sgi.com> "from Michael Reed at Apr 24, 2006 10:07:18
 am"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

Michael Reed wrote:
> See my post on 4/21:
> 
> 	"2.6.17-rc2: kobject_add failed"
> 
> 	http://marc.theaimsgroup.com/?l=linux-scsi&m=114563629810793&w=2
> 
> Perhaps this is related?
> 
> http://marc.theaimsgroup.com/?t=114443491400001&r=1&w=2

My "kobject_add failed" issue with 2.6.17-rc1 and -rc2 was a previously
undiscovered code error in the Alpha-specific strncpy() routine.  See
http://marc.theaimsgroup.com/?t=114555387000005&r=1&w=2
for the gory details.  Ivan Kokshaysky provided the fix, which I hope
has been captured for inclusion in -rc3.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
