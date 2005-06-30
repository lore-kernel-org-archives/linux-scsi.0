From: Douglas Gilbert <dougg@torque.net>
Subject: Re: 64-bit SCSI LUN addressing on Linux
Date: Thu, 30 Jun 2005 12:57:00 -0400
Message-ID: <42C4245C.8010008@torque.net>
References: <42C41745.1020302@datadirectnet.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts25.bellnexxia.net ([209.226.175.188]:8924 "EHLO
	tomts25-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S263006AbVF3Q4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 12:56:20 -0400
In-Reply-To: <42C41745.1020302@datadirectnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Martin W. Schlining III wrote:
> Does Linux support 64-bit SCSI LUN addressing?

No. Linux supports 32 bit LUNs.

> Suppose I have a system 
> that can create SCSI LUNs that are greater than 2TB using a block size 
> of 512 bytes and can accept 16 byte CDBs, can I use this LUN with a 2.6 
> series Linux kernel?

There is no relationship between 64 bit LUNS (which,
for example, support a hierarchy of up to 4, 16 bit LUNs)
and the ability of a logical unit (LU) (e.g. a disk) to
support 64 bit logical block addressing (LBA).

Christoph's reply more accurately addresses the question
I think you were trying to ask...

In your title perhaps you could: s/LUN addressing/LBAs/
LUNs are about device addressing; LBAs are about block
(or sector) addressing on a block device.


Doug Gilbert
