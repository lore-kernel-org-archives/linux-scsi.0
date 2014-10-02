From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 02 Oct 2014 15:18:14 +0200
Message-ID: <542D5096.9010503@redhat.com>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com> <1412244280-15111-2-git-send-email-hdegoede@redhat.com> <20141002112627.GC17628@infradead.org> <542D467E.2020400@redhat.com> <20141002130654.GA17051@infradead.org> <542D4E58.5000809@redhat.com> <20141002131259.GA930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaJBNSr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 09:18:47 -0400
In-Reply-To: <20141002131259.GA930@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On 10/02/2014 03:12 PM, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 03:08:40PM +0200, Hans de Goede wrote:
>> Yes, although that likely would need to go through stable, without
>> going into 3.18 .
>>
>> Greg, is this ok with you and how do I get a patch in stable which
>> is not in upstream (because upstream will get a better fix) ?
> 
> This is a trivial one liner and 3.17 isn't released yet, so can you just
> send it to Linus now?

I don't think it is that urgent, given that block-mq is disabled by default
in 3.17 AFAIK. But feel free to send such a patch directly to Linus with my:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Added, if that gets in, I guess I then need to do a v2 of the patch
from $subject, reverting it.

Regards,

Hans
