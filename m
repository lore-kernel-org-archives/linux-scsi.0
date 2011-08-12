From: Artem Bokhan <aptem@ngs.ru>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 16:17:34 +0700
Message-ID: <4E44EFAE.9010800@ngs.ru>
References: <4E43F2C3.9000808@computerix.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout17.ngs.ru ([195.93.186.223]:59044 "EHLO smtpout17.ngs.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1HLJXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 05:23:09 -0400
Received: from smtpout.ngs.ru (imx.in.ngs.ru [172.16.0.3])
	by smtpout17.ngs.ru (smtpout17.ngs.ru) with ESMTP id 626AC71DA4CB
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 16:18:12 +0700 (NOVST)
In-Reply-To: <4E43F2C3.9000808@computerix.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Cc: linux-scsi@vger.kernel.org

On 11.08.2011 22:18, Prof. Dr. Klaus Kusche wrote:
> I'm looking for ways to hook up fast 6 Gb/s SATA SSD's (non-RAID!)
> to (server or i-X58) mainboards which do not have native 6 Gb/s SATA.
>
> From the reviews I've read so far, two things became obvious:
> * The SSD's I'm looking at really want a working SATA TRIM command.
> * All the onboard Marvell 88SE9128 (or ASmedia) solutions
> seriuosly lack performance, as do PCIe cards based on those chips.
>
> So basically, there seem to be two choices:
> 1.) LSI 2008

IT firmware supports TRIM. You may use 
ftp://ftp.supermicro.com/driver/SAS/LSI/2008/ tools to flash IR firmware instead 
of iMR (megaraid), then flash to IT firmware. Then you may flash latest IT 
firmware to ensure that TRIM is supported.
