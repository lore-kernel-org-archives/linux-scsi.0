From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] iscsi: fix setting of pid from netlink skb
Date: Sat, 18 Feb 2012 16:06:00 -0600
Message-ID: <1329602760.2862.35.camel@dabdike>
References: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
	 <1327633991-2615-2-git-send-email-michaelc@cs.wisc.edu>
	 <CAO+b5-o8GoYaTx=c9E+8vDJdkDR53YceUCQTu+VSpO9ZUeL6iA@mail.gmail.com>
	 <4F225446.1000709@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50011 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582Ab2BRWGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2012 17:06:03 -0500
In-Reply-To: <4F225446.1000709@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

On Fri, 2012-01-27 at 01:37 -0600, Mike Christie wrote:
> On 01/27/2012 01:04 AM, Bart Van Assche wrote:
> > On Fri, Jan 27, 2012 at 4:13 AM, <michaelc@cs.wisc.edu> wrote:
> >> NETLINK_CREDS's pid now returns 0, so I guess we are supposed to
> >> be using NETLINK_CB. This changed while the patch to export the
> >> pid was getting merged upstream, so it was not noticed until both
> >> the network and iscsi changes were in the same tree.
> >>
> >> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > 
> > If my analysis is correct this patch has not only to be applied on the
> > master branch but also on kernel 3.2. Shouldn't "Cc:
> > stable@vger.kernel.org #3.2" be added here ? See also
> > http://www.spinics.net/lists/netdev/msg185565.html.
> > 
> 
> The iscsi code that uses the pid just got merged in the 3.3 feature
> window, so no need.
> 
> Also for stable, I think we normally just tell James it should go in
> stable and then he does some magic. In the past, when he knows it should
> go there, when the patch gets merged and sent upstream the stable people
> were notified automagically.

That's the

cc: stable@kernel.org

tag in the commit ... but don't necessarily rely on me to add this.  I
do add it in a few cases, but I do need people to indicate should go to
stable by adding the cc: in their commit, otherwise I have to guess.

James


