From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: RE: Degraded I/O performance, since 2.5.41
Date: Fri, 11 Oct 2002 09:49:23 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0376B0@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: 'Dave Hansen' <haveblue@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org




> From: Dave Hansen 
> James Bottomley wrote:
> > OK, this patch should fix it.  Do your performance numbers 
> for ips improve 
> > again with this?
> 
> Yes, they are better, but still about 10% below what I was seeing 
> before.  Thank you for getting this out so quickly.  I can do 
> reasonable work with this.
> 
> Are the ServeRAID people aware of this situation?  Do they know that 
> their performance could be in the toliet if they don't 
> implement queue 
> resizing in the driver?
> -- 
> Dave Hansen
> haveblue@us.ibm.com
> 

Dave,

Thank you for for adding me to the CC list.  I didn't realize how the
queueing work would affect scsi drivers.

I'm using an older 2.5 kernel so I hadn't seen the performance drop.
I'll update my kernel and get to work on it next week when I have
time.

David Jeffery
