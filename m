From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Mon, 16 Feb 2009 04:27:30 -0500
Message-ID: <49993182.3010707@garzik.org>
References: <1234185129-31858-1-git-send-email-bharrosh@panasas.com>	<20090216131806X.fujita.tomonori@lab.ntt.co.jp>	<499928A3.60507@panasas.com> <20090216180028C.fujita.tomonori@lab.ntt.co.jp> <49992F99.1060404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48774 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZBPJ1q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2009 04:27:46 -0500
In-Reply-To: <49992F99.1060404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, avishay@gmail.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> FUJITA Tomonori wrote:
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> Also looking
>>> ahead I will have RAID 0, 1, 5, and 6 on objects of different devices. bio
>>> is the perfect collector for memory information in this situation.

>> You will add such features to exofs, handling multiple devices
>> internally?

> Multiple objects on Multiple devices, Yes.

That sort of feature does not belong in exofs, but somewhat separate. 
Ideally we should be able to share "MD for OSD" with other OSD 
filesystems, and the "osdblk" device that I will produce once libosd 
hits upstream.

	Jeff




