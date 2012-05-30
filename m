From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] bnx2fc: use kthread_create_on_node
Date: Tue, 29 May 2012 17:33:04 -0700
Message-ID: <1338337984.18974.30.camel@joe2Laptop>
References: <1311923178.7845.21.camel@edumazet-laptop>
	 <4E33088A.80903@broadcom.com> <4FC56943.6000304@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53617 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753756Ab2E3AdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2012 20:33:06 -0400
In-Reply-To: <4FC56943.6000304@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

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

Do tell if James wakes up from his slumber to
actually apply trivially correct but perhaps
what he considers unnecessary, bothersome patches.


