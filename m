From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sat, 02 Apr 2011 14:10:50 -0400
Message-ID: <4D9766AA.4020906@garzik.org>
References: <20110401202051.GL4183@linux.intel.com> <20110402133643.GB18990@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60541 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab1DBSKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2011 14:10:53 -0400
Received: by qwk3 with SMTP id 3so2669333qwk.19
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2011 11:10:52 -0700 (PDT)
In-Reply-To: <20110402133643.GB18990@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On 04/02/2011 09:36 AM, Christoph Hellwig wrote:
> On Fri, Apr 01, 2011 at 04:20:51PM -0400, Matthew Wilcox wrote:
>>
>> In preparation for moving some drivers out from under the host_lock,
>> make cmd_serial_number an atomic.
>
> The right fix is to stop abusing cmd_serial_nubmer in those few
> drivers, and use a driver-private and more scalable lookup data
> structure than a linear list search.

Agreed.


