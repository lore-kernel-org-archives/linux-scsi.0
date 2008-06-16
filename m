From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC v2] allow userspace to modify scsi command filter
 on per device basis
Date: Mon, 16 Jun 2008 15:13:28 +0900
Message-ID: <20080616151328Q.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0806132351r20fe8f91o479cd102978fa483@mail.gmail.com>
	<20080616115952W.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:55251 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYFPGP4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 02:15:56 -0400
In-Reply-To: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, matthew@wil.cx, linux-scsi@vger.kernel.org, pjones@redhat.com, jens.axboe@oracle.com

On Mon, 16 Jun 2008 07:49:49 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> 2008/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > On Sat, 14 Jun 2008 08:51:16 +0200
> > "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
> >
> >> Attached a new version of the patch.
> >> Moved the sysfs entry up one level (to not be in the "holders"
> >> directory) and renamed it t cmd_filter (reflects its purpose better
> >> than "filter").
> >>
> >> -----------------------------
> >>
> >> From: Peter Jones <pjones@redhat.com>
> >>
> >> This patch exports the per-gendisk command filter to user space through
> >> sysfs, so it can be changed by the system administrator.
> >>
> >> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> >> Signed-off-by: Peter Jones <pjones@redhat.com>
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >
> > I think that the scsi command filter infrastructure should work with
> > all the interfaces, bsg, SG_IO, and sg. This doesn't work with sg,
> > right?
> >
> 
> sg never used any command filtering. (I have converted all users of
> the old command filter to the new one).

No, sg has own command filtering mechanism, see sg_allow_access().

When we discussed the per-gendisk command filter before, I think that
we agreed that we had better to have one command filtering mechanism.


> It allowed any scsi command without checking but normally /dev/sg* is
> only accessable by root anyway.
