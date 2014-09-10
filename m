From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 17/21] uas: Do not log urb status error on cancellation
Date: Wed, 10 Sep 2014 16:05:42 +0200
Message-ID: <54105AB6.2090002@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>	 <1410349611-17573-18-git-send-email-hdegoede@redhat.com> <1410357603.12706.27.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaIJOFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 10:05:49 -0400
In-Reply-To: <1410357603.12706.27.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

On 09/10/2014 04:00 PM, Oliver Neukum wrote:
> On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
>> Check for both type of cancellation codes for sense and data urbs.
> 
> Then you should also check for -ESHUTDOWN (unplug of HC)

The intent here is to stop log pollution when cancelling because
of an abort / bus-reset. When people unplug a device with io pending
they deserve all the log pollution they get IMHO. Also most of the
time things seem to end with -EPROTO then.

Regards,

Hans
