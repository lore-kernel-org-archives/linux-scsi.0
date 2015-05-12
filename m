From: John Garry <john.garry@huawei.com>
Subject: libsas and pci driver
Date: Tue, 12 May 2015 13:56:44 +0000
Message-ID: <FF9EFDB6B8B51C49B6C1EFD8F01AB4DEA69601@lhreml504-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lhrrgout.huawei.com ([194.213.3.17]:3692 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbELN5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 09:57:02 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

I am looking to design an upstreamable driver for a custom SAS host controller and I have a question on libsas: the documentation for libsas states that the LLDD is a pci device driver - is this necessary? Our HBA is connected on the system bus, so would require a platform driver.

Regards,
John
