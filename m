From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Wed, 5 Dec 2007 11:30:32 -0600 (CST)
Message-ID: <20071205173032.8257ADBA2@gherkin.frus.com>
References: <20071204121618.GA26132@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:47000 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLERaj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 12:30:39 -0500
In-Reply-To: <20071204121618.GA26132@elte.hu> "from Ingo Molnar at Dec 4, 2007
 01:16:18 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Cree <mcree@orcon.net.nz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>

Current progress: 11 revisions left to test.  The current partial
"git bisect log" is available per Ingo's suggestion on bugzilla.

http://bugzilla.kernel.org/show_bug.cgi?id=9457

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
