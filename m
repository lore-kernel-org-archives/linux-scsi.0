From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lsscsi-0.09
Date: Fri, 4 Apr 2003 12:46:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030404124617.A24518@infradead.org>
References: <3E8D1D76.7050203@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:24332 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263653AbTDDLew (for <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2003 06:34:52 -0500
Content-Disposition: inline
In-Reply-To: <3E8D1D76.7050203@torque.net>; from dougg@torque.net on Fri, Apr 04, 2003 at 03:51:50PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 04, 2003 at 03:51:50PM +1000, Douglas Gilbert wrote:
> lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
> to list information about all SCSI devices (including devices
> that use the SCSI stack such as USB mass storage devices)
> and SCSI hosts. Both a compact format (default), one line
> per device, and a "classic" format (like the output of
> 'cat /proc/scsi/scsi') are supported for devices.

That reminds me that I wanted to get rid of /proc/scsi/scsi eventually.
Does someone have an idea for a replacement of it's write routine?
Some of them don't fit nicely into the sysfs model unfortunatley.

