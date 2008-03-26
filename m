From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 6868] Crash with Nat consumption in sg_add
Date: Wed, 26 Mar 2008 07:43:08 -0700
Message-ID: <1206542588.3019.10.camel@localhost.localdomain>
References: <20080326090719.667CF10803B@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37201 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbYCZOnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 10:43:12 -0400
In-Reply-To: <20080326090719.667CF10803B@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-26 at 02:07 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=6868

> ------- Comment #3 from protasnb@gmail.com  2008-03-26 02:07 -------
> If the patch is still needed, please submit it to LKML, otherwise it won't be
> reviewed/picked up. 

I can certainly promise you that the patch won't apply:  The sg_dev_arr
was removed by this:

commit 7c07d613d22680f1caf2bd9ee49838ec7730b9da
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Sun Aug 5 13:36:11 2007 -0500

    [SCSI] sg: use idr to replace static arrays

However, since the root cause is an unhandled failure of
class_device_add, I think it has been fixed by this:

commit d07e03610ca1f4be373f32ad5b25ac00dbdb867d
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Jan 15 13:18:00 2008 +0900

    [SCSI] sg: handle class_device_create failure properly

James


