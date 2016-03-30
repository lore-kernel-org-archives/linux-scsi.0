From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH v2 0/2] Update SCSI target removal path
Date: Wed, 30 Mar 2016 13:09:22 -0400 (EDT)
Message-ID: <1213304373.25876453.1459357762438.JavaMail.zimbra@redhat.com>
References: <cover.1459249252.git.jthumshirn@suse.de> <1459261538.30035.12.camel@localhost.localdomain> <yq1twjorday.fsf@sermon.lab.mkp.net> <da1b6206f0fba95e252e952a3afa07a6@suse.de> <1459355427.30035.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38687 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbcC3RJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2016 13:09:54 -0400
In-Reply-To: <1459355427.30035.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: jthumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

I can test this next week.
I can test pre and then post patch.
Will update when its validated.

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Ewan D. Milne" <emilne@redhat.com>
To: "jthumshirn" <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Hannes Reinecke" <hare@suse.de>, "Christoph Hellwig" <hch@infradead.org>, linux-scsi@vger.kernel.org
Sent: Wednesday, March 30, 2016 12:30:27 PM
Subject: Re: [PATCH v2 0/2] Update SCSI target removal path

On Wed, 2016-03-30 at 13:01 +0200, jthumshirn wrote:
> [+Cc linux-scsi back]
> On 2016-03-30 02:59, Martin K. Petersen wrote:
> >>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:
> > 
> > Ewan> I would probably use an APCON or other physical layer switch to
> > Ewan> drop the FC link and test the error recovery/device loss.  But we
> > Ewan> don't have one.
> > 
> > They go for a couple of hundred bucks on eBay. I had one of these in a
> > previous life and it was awesome.
> 
> Though this would work (like any other FC/FCoE switch) I thought more of 
> a simulated environment. scsi_debug, Qemu, something like that.

You might be able to do something with that but it doesn't quite do the
same thing in terms of how a HBA/driver will react to a fault.  You also
need to be sure there is enough entropy in the timing of when the target
goes away.  (Otherwise, you could just rmmod scsi_debug...)

> 
> I've had a look at scsi_debug but it seems like it's quite some 
> refactoring needed to get it to a point where one can simulate target 
> errors. I kinda like the idea of having something in 
> tools/testing/selftest but it'll probably end up with a FC switch.
> 
> Johannes


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
