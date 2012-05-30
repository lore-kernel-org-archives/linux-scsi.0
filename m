From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bnx2fc: use kthread_create_on_node
Date: Wed, 30 May 2012 12:30:11 +0400
Message-ID: <1338366611.3229.8.camel@dabdike>
References: <1311923178.7845.21.camel@edumazet-laptop>
	 <4E33088A.80903@broadcom.com> <4FC56943.6000304@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33153 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab2E3IaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 04:30:16 -0400
In-Reply-To: <4FC56943.6000304@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>

On Tue, 2012-05-29 at 17:26 -0700, Bhanu Prakash Gollapudi wrote:
> On 7/29/2011 12:22 PM, Bhanu Prakash Gollapudi wrote:
> > On 7/29/2011 12:06 AM, Eric Dumazet wrote:
> >> Since bnx2fc_percpu_thread_create() creates percpu kthread, it makes
> >> sense to use kthread_create_on_node() to get proper NUMA affinity for
> >> kthread stack.
> >>
> >> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> >> CC: "James E.J. Bottomley"<JBottomley@parallels.com>
> >
> > Thanks Eric.
> >
> > Acked-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
> 
> James, I found a couple of old patches that were not applied, this being 
> one and the other - http://marc.info/?l=linux-scsi&m=132561632116410&w=2.
> 
> Please let me know if you want the patches to be resubmitted, as they 
> are a bit old now.

Yes, please.  And for future reference, if I ever miss anything you want
in, just fold it into your internal queue and resend for your next batch
(with the appropriate signoffs).

Thanks,

James


