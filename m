From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: cleanup of sd driver in lk2.5
Date: Sun, 14 Apr 2002 10:32:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204141532.g3EFWfk09653@localhost.localdomain>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Thu, 04 Apr 2002 23:48:10 EST." <3CAD2C8A.595DC7A5@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

dougg@torque.net said:
> I noticed that James Bottomley has a BK archive. Perhaps this driver
> could be put in there so others can hack it. There are lots more
> things I would like to do/fix with this driver. 

I think a bitkeeper tree would be a very good idea.  Unfortunately, it can't 
be mine since it sits behind a firewall.  However, the Bitmover project will 
give us a publicly accessible one on bkbits.net.

If no one else volunteers, I'll set up a linux-scsi.bkbits.net for us.  Does 
anyone have any specific thoughts on the layout of the subprojects?  For 
bitkeeper to be useful, you should have as many sub-projects as there are 
lines of development in the tree.  The incredibly rough split I thought of 
would be:

scsi-midlayer - any changes to the midlayer alone

sd, st, sg - obvious

drivers - most drivers are single .c and .h files that don't change very much, 
so splitting them out only makes sense if they're being updated on a regular 
basis

<evolving drivers> - need more input on this one, which drivers need separate 
sub-projects, the sub projects can be owned by the various driver maintainers?

misc - everything else.

This can be refined later on, but it is useful to get the split reasonably 
correct first time around.

Administering a bkbits.net tree is quite a bit different from looking after 
your own bitkeeper tree, so if anyone else has experience in this area, now 
would be a good time to volunteer.

James



