From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 15:57:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400CC32C.8060601@torque.net>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <20040119193354.GC967@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:2058 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S265101AbUATF7Q
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 00:59:16 -0500
In-Reply-To: <20040119193354.GC967@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Christoph Hellwig [hch@infradead.org] wrote:
> 
>>+/**
>>+ * ipr_version_show - Show the driver version
>>+ * @dd:	device driver struct
>>+ * @buf:	buffer
>>+ * 
>>+ * Return value:
>>+ * 	number of bytes printed to buffer
>>+ **/
>>+static ssize_t ipr_version_show(struct device_driver *dd, char *buf)
>>+{
>>+	return snprintf(buf, PAGE_SIZE, "%s\n", IPR_DRIVER_VERSION);
>>+}
>>+
>>+static DRIVER_ATTR(version, S_IRUGO, ipr_version_show, NULL);
>>
>>Please don't do this in sysfs.  We're still hoping for a MODULE_VERSION
>>macro, but every driver crafting it's own version telling mechanism
>>doesn't scale.
>>
> 
> 
> This is my fault. We recommended not to include procfs info in this
> driver and pointed to sysfs. Do we have a timeline on MODULE_VERSION?

... and will MODULE_VERSION be defined when the driver is built in?

Doug Gilbert


