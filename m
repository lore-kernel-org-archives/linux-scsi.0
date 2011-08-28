From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: sysfs attributes of SCSI hosts
Date: Sun, 28 Aug 2011 19:59:46 +0200
Message-ID: <CAPXgP10Ry6+iqRdxnUgv910ZnYspet+tb0ctjgGM-A-w5RScaA@mail.gmail.com>
References: <CAO+b5-q=yyuoeBCZFzpTDWpsr8KGQQDJ-B3s6X68=BoDD1=2Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59444 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1H1SAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 14:00:06 -0400
Received: by yie30 with SMTP id 30so2970494yie.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 11:00:06 -0700 (PDT)
In-Reply-To: <CAO+b5-q=yyuoeBCZFzpTDWpsr8KGQQDJ-B3s6X68=BoDD1=2Pw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Aug 28, 2011 at 15:08, Bart Van Assche <bvanassche@acm.org> wrote:
> Does that mean that udev rules similar to the above will work for
> setting the value of the default SCSI host attributes but that any
> attempt to use a similar rule for any attribute defined via
> shost_attrs is racy?

Yes, it's a known limitation, they can not safely be used from a
hotplug event handler.

> Has anyone been looking into this before ?

No, we only fixed the common attributes to work properly from udev,
not the custom attributes.

Kay
