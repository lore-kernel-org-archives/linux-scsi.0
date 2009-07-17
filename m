From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: Recommended HBA management interfaces
Date: Fri, 17 Jul 2009 07:16:03 -0600
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:54325 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbZGQN0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2009 09:26:35 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n6HDGDuI012514
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 06:16:13 -0700 (PDT)
Received: from coscas01.lsi.com (coscas01.co.lsil.com [172.21.36.60])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n6HDG7aq021478
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 06:16:15 -0700
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi All,

We would like expert comments on the following questions regarding management of HBA from applications.

Traditionally, our drivers create a character device node, whose file_operations are then used by the management applications to transfer HBA specific commands. In addition to being quirky, this interface has a few limitations which we would like to remove, most important being able to seamlessly handle asynchronous events with data transfer.

1. What is (are) the other standard/recommended interfaces which applications can use to transfer HBA specific commands and data.

2. How should an LLD implement interfaces to transmit asynchronous information to the management applications? The requirement is to be able to transmit data buffer as well as notifications for events.

3. The interface should be able to work even if no SCSI devices are exported to the kernel.

4. Should work seamlessly across vmware and xen kernels.

Thanks
Atul Mukker
LSI Corp.
