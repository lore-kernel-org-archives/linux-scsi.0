From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 0/3]: blk-iopoll, a polled completion API for block
	devices
Date: Tue, 11 Aug 2009 12:35:13 +0200
Message-ID: <e2e108260908110335tc500412mc6354359d85ae9b6@mail.gmail.com>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53795 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZHKMEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 08:04:10 -0400
Received: by ewy10 with SMTP id 10so3712908ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 05:04:10 -0700 (PDT)
In-Reply-To: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, jeff@garzik.org

On Thu, Aug 6, 2009 at 9:58 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> Anyway, YMMV, I would appreciate some test results (and as usual, that
> even includes just saying that it boots and functions for you). If
> people feel adventurous, patches for other controllers will be happily
> queued up for testing. I may even be convinced to implement support
> for your controller of choice, if you have some fast storage hooked up
> and would like to experiment. Generally, adding support to a driver is
> not very hard and the two conversions included were also meant to serve
> as an inspiration.

Sounds very interesting. Have you already considered patching the SRP
initiator ? During the SRP performance tests I ran CPU usage on the
initiator was more than 95% and on the target less than 10%.

Bart.
