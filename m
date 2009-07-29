From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Wed, 29 Jul 2009 17:09:53 +0300
Message-ID: <4A705831.3010002@panasas.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:28985
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbZG2OJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 10:09:59 -0400
In-Reply-To: <1248875763.3900.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/29/2009 04:56 PM, James Bottomley wrote:
> On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
>> scsi/scsi.h is exported to userspace, so it should
>> use __u8 instead of u8 as other userspace-visible headers do.
> 
> Actually, can we just put a hold on this until we decide what we're
> doing with exporting include/scsi.
> 
> Arguments so far are
> 
>      1. Don't export and let glibc supply the headers (as it does now)
>      2. Move headers to be exported to include/linux
>      3. Take over include/scsi export from glibc: this will necessitate
>         comparing our current headers and those of glibc and moving
>         stuff around.
> 

I'm all for 3. I think if done we should do it for all include/scsi at once.
No need for prolonged pain.

[]$ ls /usr/include/scsi
scsi.h
scsi_ioctl.h
scsi_tgt_if.h
sg.h

However I'll have to ask my employers if they can spare me, so any other
volunteers?

TODO:
* Fix up Kernel headers by complying to check_headers
* Test drive some example user-mode applications including glibc itself.
* send patches to glibc
* send patches to Kernel
* Notify distributions.

> James
> 

Boaz
