From: "George Spelvin" <linux@horizon.com>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: 27 Sep 2010 07:08:42 -0400
Message-ID: <20100927110842.2601.qmail@science.horizon.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:50346 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751635Ab0I0LIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 07:08:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, linux-raid@vger.kerne.org, linux-scsi@vger.kernel.org
Cc: linux@horizon.com

Has this bug been merged?  I'm getting a boot-time BUG referencing this
line in a raid1 task with 2.6.36-rc5, and I thought the fix had been
merged in.

At least, 2c7d46ec192e4f2b350f67a0e185b9bce646cd6b looks looks like
the fix, but I have that in my kernel (which, to be absolutely clear,
is b30a3f6257ed2105259b404d419b4964e363928c plus a few unrelated local
patches that I just manually reviewed to make absolutely certain),
and I'm still exploding on boot.

If someone would like the full error message, I can find a camera to take
a picture of the screen.

Thanks!
