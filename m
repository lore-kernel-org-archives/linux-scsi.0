From: Doug Ledford <dledford@redhat.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 22:18:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D911CF6.3020001@redhat.com>
References: <20020924233941.A9952@flint.arm.linux.org.uk> <200209242314.g8ONEHU02783@localhost.localdomain> <20020924232630.GD1330@beaverton.ibm.com> <20020925003335.D9952@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Russell King wrote:
> There is a trivial but required fix that I should backport from 2.5 to
> 2.4; that's the one that limits the number of command retries in
> scsi_error.c.  I'm not sure if Doug Ledford picked that one up though.
> Doug?

I haven't even caught up entirely yet from being gone so much the last 
two weeks, so I seriously doubt it (and I don't remember it).




-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
          Red Hat, Inc.
          1801 Varsity Dr.
          Raleigh, NC 27606


