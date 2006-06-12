From: Martin Bligh <mbligh@mbligh.org>
Subject: Re: Fw: [Bugme-new] [Bug 6657] New: Domain validation failures on
 aic7xxx
Date: Mon, 12 Jun 2006 10:06:23 -0700
Message-ID: <448D9F0F.4080106@mbligh.org>
References: <20060606091840.a39afe5a.akpm@osdl.org>	 <1149956760.3335.18.camel@mulgrave.il.steeleye.com>	 <448D9A92.1050406@mbligh.org> <1150131252.3413.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dvhart.com ([64.146.134.43]:43162 "EHLO dvhart.com")
	by vger.kernel.org with ESMTP id S1750968AbWFLRG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 13:06:26 -0400
In-Reply-To: <1150131252.3413.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: william@brodie-tyrrell.org, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2006-06-12 at 09:47 -0700, Martin Bligh wrote:
> 
>>It's not going to auto-forward, otherwise every update to bugs owned
>>by
>>the virtual alias will come through. What I was planning was to cc
>>linux-scsi on emails to bugme-new (ie one email per new bug only) for
>>that category only. I'll try to get that going this morning ...
> 
> 
> Yes ... that's what we want.  An email that can be replied to and will
> go to the submitter and linux-scsi and be captured by bugzilla.

OK, set up. It should reply to bugme-daemon, which should result up
being back in the DB ... all emails should be tagged with [bugme-new]
in them, so its easy to filter if need be.

I cc'ed IO/storage-SCSI, and all the SCSI drivers ones. If that's not
correct, or you have other problems with it, let me know.

Hitting reply-all may result in mail to bugme-new as well as 
bugme-daemon ... a mild pain, but should get caught by the list
filtration, so no big deal, I think.

M.


