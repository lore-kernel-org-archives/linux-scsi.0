From: Luben Tuikov <luben@splentec.com>
Subject: Re: Should sd REALLY allocate a device for an offline device
Date: Fri, 14 Mar 2003 14:33:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E722EA7.7040802@splentec.com>
References: <bj147v0fn10c6duj1n06jo84uurn1i0dvj@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Steve Brueggeman <xioborg@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Steve Brueggeman wrote:
> There's a managed storage device that reports 0x20 in byte 0 of the
> Inquiry data, which means it's a SCSI_DISK, but the LUN is detached.

The physical device is not currently attached to the LU, but the device
is supported and we know a fait bit about it from the INQUIRY data.

> scan_scsis_single() acknowledgs this, and marks the device as not
> online, and lets the upper level device drivers decide what to do.

This is the right thing to do.

> It is my belief that if a device is not online, the scsi disk driver
> should not allocate a device slot for it.  See the following simple
> patch.  Any thoughts?  It seems obvious to me, but maybe I'm missing
> something.

As was already answered, a device being ``offline'' doesn't mean that's
it's not there.  In the simplest terms it means that the LU device server
cannot process any commands addressed to the physical device at this moment.

-- 
Luben


