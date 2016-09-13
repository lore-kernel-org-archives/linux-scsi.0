From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: do not print 'reservation conflict' for TEST UNIT
 READY
Date: Tue, 13 Sep 2016 08:06:18 -0700
Message-ID: <1473779178.2214.9.camel@HansenPartnership.com>
References: <1473668453-115818-1-git-send-email-hare@suse.de>
         <1473775496.2214.6.camel@HansenPartnership.com>
         <18995c82-c3b1-89f1-9336-dafe9169963c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60372 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758747AbcIMPG0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 11:06:26 -0400
In-Reply-To: <18995c82-c3b1-89f1-9336-dafe9169963c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, 2016-09-13 at 16:24 +0200, Hannes Reinecke wrote:
> On 09/13/2016 04:04 PM, James Bottomley wrote:
> > You could argue that the entire message needs removing, since it's
> > reporting stuff that mostly only shows when systems using 
> > reservations correctly are in operation.
> > 
> Oh, I'm perfectly fine with that.
> I'm happy to send a patch removing that line altogether.

OK, how about lowering the priority to KERN_DEBUG so it can still be
seen, just not usually.

James


