From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Fri, 20 Sep 2013 17:00:00 -0400
Message-ID: <CAAzz28hzVRd89Sw_-rOoPAc126W5uMjZzXHMxo2ge4OzOvwMTA@mail.gmail.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
	<20130920203222.GA14306@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45461 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3ITVAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 17:00:02 -0400
In-Reply-To: <20130920203222.GA14306@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org

I am thinking Srini meant in the sd_mod driver module.
#define SD_FLUSH_TIMEOUT (60 * HZ)

Laurence


On Fri, Sep 20, 2013 at 4:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
>> The SD_FLUSH_TIMEOUT value is currently hardcoded.
>
> Hardcoded where?  Please, more context.
>
>> On our cloud, we sometimes hit this timeout. I was wondering if we
>> could make this a module parameter. If this is acceptable, I can send
>> you a patch for this.
>
> A module parameter don't make sense for a per-device value, does it?
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
