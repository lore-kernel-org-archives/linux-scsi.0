From: Doug Ledford <dledford@redhat.com>
Subject: Re: SCSI reserve/release
Date: Thu, 27 Feb 2003 18:32:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5EA009.2070401@redhat.com>
References: <20030227205135.31139.qmail@web14612.mail.yahoo.com> <20030227225334.GB14200@nbkurt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030227225334.GB14200@nbkurt>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linda Lee <lindaclee2002@yahoo.com>, linux-scsi@vger.kernel.org

Kurt Garloff wrote:

> You can do this. But note that you will lose the reservation
> on a reset of the SCSI bus which can occur due to error handling
> of your box (or another one). As long as the kernel does not
> keep track of reservation states (or you invent some notification
> mechanism for SCSI resets to user space), you can't handle this
> reliably.

That's not entirely true.  The package I posted a note about a few 
minutes ago does in fact handle this via a means of cooperative 
reservation operations.  In other words, you can't do it reliably in a 
hostile environment, but by enacting a few policy rules (which my app 
does) and then adhering to those rules, you can.


-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
          Red Hat, Inc.
          1801 Varsity Dr.
          Raleigh, NC 27606


