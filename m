From: yang jun <yangjun.donglife123@gmail.com>
Subject: Re: [SCSI] sr: sr_mutex ,multi-drive performance is bad
Date: Tue, 29 Oct 2013 22:06:01 +0800
Message-ID: <CAO4Pk4x2zMSWUWFvc9Pxp23=Jm+-obe49Po-feJrCPpL+ribMw@mail.gmail.com>
References: <CAO4Pk4wxUN-O_m5KcdZgmTTRG2w8icqva+0dxu7HRO=rEpbArg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61545 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3J2OGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 10:06:03 -0400
Received: by mail-vc0-f179.google.com with SMTP id hz11so3068112vcb.24
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2013 07:06:02 -0700 (PDT)
In-Reply-To: <CAO4Pk4wxUN-O_m5KcdZgmTTRG2w8icqva+0dxu7HRO=rEpbArg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: otto.patches@sister-shadow.de
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

Dear Mr.Meta

I saw your patch about sr_module, I very curious why the latest kernel
still keep sr_mutex. Can sr_mutex be deleted just like sd_module?

Yours Sincerely

2013/10/28 yang jun <yangjun.donglife123@gmail.com>:
> Dear Mr.Axboe,
>
> The latest kernel sr_module still uses single mutex,it will serialise
> all sr ioctls. Otto Meta had mentioned this on Jan 1st, 2013 . Some
> record tools such as growisofs use SG_IO to write data to disc, so if
> there are multiple cdroms being recorded at the same time=A3=ACit wil=
l be
> very slowly.
>
> I saw sd_module before,it had removed BKL and made "openers" atomic_t
> in scsi_disk. Shall we do the same thing to sr_module? That is, to
> remove sr_mutex and make "use_count" atomic_t in cdrom_device_info.
>
> Yours Sincerely,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
