From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Cleanup for sd in 2.4.19
Date: Thu, 08 Aug 2002 09:31:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208081431.g78EVEb01989@localhost.localdomain>
References: <zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA09133
	for <linux-scsi@vger.kernel.org>; Thu, 8 Aug 2002 07:31:20 -0700
In-Reply-To: Message from Pete Zaitcev <zaitcev@redhat.com>
   of "Thu, 08 Aug 2002 01:58:06 EDT." <20020808015806.B10154@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-scsi@vger.kernel.org

zaitcev@redhat.com said:
> A pure cleanup here. I know that something that works should not be
> fixed, but cheesh. There are limits to everything. I cannot wait until
> James destroys all this crap, it's just too painful to read. 

I didn't sign up to clean out the Augean Stables on my own.  I'm trying to 
rationalise the substance.  Beautifying the structure when not part of a 
substantive change (however painful it may be to the eye) isn't high on my 
list of priorities.  And 2.4 is nowhere; I'm working on 2.5 almost exclusively.

The patch looks fine to me: send it off to Marcelo---he's been wanting to get 
into SCSI coding anyway, so he might be interested in helping out on this type 
of work.

Oh, and if the same problem persists in 2.5, I'll take patches (or you can 
toss them over the wall at Doug Leadford).

James


