From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH/RFC v2] allow userspace to modify scsi command filter on per device basis
Date: Mon, 16 Jun 2008 07:49:49 +0200
Message-ID: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>
References: <6cf6b73e0806131322n7642d2d1ne90f70c2b3728f8@mail.gmail.com>
	 <6cf6b73e0806131323w5b921c05jd1166ab88471bfd1@mail.gmail.com>
	 <6cf6b73e0806132351r20fe8f91o479cd102978fa483@mail.gmail.com>
	 <20080616115952W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:15546 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYFPFtv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 01:49:51 -0400
Received: by fg-out-1718.google.com with SMTP id 19so3180814fgg.17
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jun 2008 22:49:50 -0700 (PDT)
In-Reply-To: <20080616115952W.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, pjones@redhat.com, jens.axboe@oracle.com

2008/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Sat, 14 Jun 2008 08:51:16 +0200
> "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
>
>> Attached a new version of the patch.
>> Moved the sysfs entry up one level (to not be in the "holders"
>> directory) and renamed it t cmd_filter (reflects its purpose better
>> than "filter").
>>
>> -----------------------------
>>
>> From: Peter Jones <pjones@redhat.com>
>>
>> This patch exports the per-gendisk command filter to user space through
>> sysfs, so it can be changed by the system administrator.
>>
>> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
>> Signed-off-by: Peter Jones <pjones@redhat.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> I think that the scsi command filter infrastructure should work with
> all the interfaces, bsg, SG_IO, and sg. This doesn't work with sg,
> right?
>

sg never used any command filtering. (I have converted all users of
the old command filter to the new one).
It allowed any scsi command without checking but normally /dev/sg* is
only accessable by root anyway.
