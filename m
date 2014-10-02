From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 02 Oct 2014 15:08:40 +0200
Message-ID: <542D4E58.5000809@redhat.com>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com> <1412244280-15111-2-git-send-email-hdegoede@redhat.com> <20141002112627.GC17628@infradead.org> <542D467E.2020400@redhat.com> <20141002130654.GA17051@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaJBNL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 09:11:28 -0400
In-Reply-To: <20141002130654.GA17051@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On 10/02/2014 03:06 PM, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 02:35:10PM +0200, Hans de Goede wrote:
>> This patch sits on top of a whole bunch of uas cleanups / fixes which
>> are going into 3.18, and which are to big of a change to backport.
> 
> Can add a patch to set disable_blk_mq for uas on 3.17 then?

Yes, although that likely would need to go through stable, without
going into 3.18 .

Greg, is this ok with you and how do I get a patch in stable which
is not in upstream (because upstream will get a better fix) ?

Regards,

Hans
