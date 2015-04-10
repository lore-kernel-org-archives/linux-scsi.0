From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 37/42] hpsa: use block layer tag for command
 allocation
Date: Fri, 10 Apr 2015 08:13:43 -0700
Message-ID: <1428678823.2178.5.camel@HansenPartnership.com>
References: <20150317200139.19856.87982.stgit@brunhilda>
	 <20150317200651.19856.77450.stgit@brunhilda> <55104616.2070303@redhat.com>
	 <07F70BBF6832E34FA1C923241E8833AB486892F9@BBYEXM01.pmc-sierra.internal>
	 <5512FF8E.9010702@hp.com> <5513FFDD.6090809@redhat.com>
	 <551419DE.5040801@hp.com> <55142178.0@redhat.com> <55142331.8060304@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32801 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932925AbbDJPNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 11:13:45 -0400
In-Reply-To: <55142331.8060304@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Webb Scales <webbnh@hp.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "Brace, Don" <don.brace@pmcs.com>, "Teel, Scott Stacy" <Scott.Teel@pmcs.com>, kevin.barnett@pmcs.com, james.bottomley@parallels.com, Christoph Hellwig <hch@infradead.org>, "Lindley, Justin" <justin.lindley@pmcs.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2015-03-26 at 11:18 -0400, Webb Scales wrote:
> At this point, I've turned this work over to Don; I presume he'll want 
> to address the bitmask search. I'll leave it up to him to decide what to 
> do about the refcount.

Is there an update on this?  Firstly the delay is going to cause you to
miss the merge window (assuming it opens on Sunday) and secondly
reviewers can get demotivated if you apparently don't address their
concerns.

James


