From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] cmdfilter: clean up sysfs interface
Date: Fri, 08 Aug 2008 17:45:08 +0900
Message-ID: <20080808174508Z.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0808020819x4501aa1cud4e6c3c9ae77558b@mail.gmail.com>
	<20080808160629H.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0808080047i550f2e6bt71d4e213f81fea87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:62555 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYHHInO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 04:43:14 -0400
In-Reply-To: <6cf6b73e0808080047i550f2e6bt71d4e213f81fea87@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, matthew@wil.cx, pjones@redhat.com, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

On Fri, 8 Aug 2008 09:47:44 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> > strchr(str, ' ') would make the intention clear here rather than using
> > '4' ?
> 
> yeah will do that

Actually you don't need strchr here. You can just use simple_strtol.
