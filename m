From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: Why is (2 < 2) true? Is it a gcc bug?
Date: Fri, 17 Jan 2014 14:55:39 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6A3592@IRSMSX105.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
 <CAFLxGvz3FKU4rgjF_uZsggjvw8TQw_Hcp42GC8Zr-wg5kiwc-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQOzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 09:55:42 -0500
In-Reply-To: <CAFLxGvz3FKU4rgjF_uZsggjvw8TQw_Hcp42GC8Zr-wg5kiwc-w@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Friday, January 17, 2014 2:58 PM Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
> Can you reproduce this using a standalone test?
> I.e:
> #include <assert.h>
> 
> int main()
> {
>         assert(2 < 2 != 1);
> 
>         return 0;
> }
> 

No, I can't of course.

Lukasz

