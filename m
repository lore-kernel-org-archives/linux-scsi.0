From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: Qlogic build question
Date: Thu, 29 Dec 2005 07:48:30 -0800
Message-ID: <7F012BDECA7C2C46BB3BB0C71B8CE019010C5A@XYUS-EX21.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus19.xyratex.com ([65.203.33.19]:59460 "EHLO
	XYUS-EX21.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S1750757AbVL2Psj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2005 10:48:39 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

According to documentation included with the Qlogic driver source
you can compile the driver for a SMP system using:

make SMP=1

Does anybody know if this will happen automtically on multiprocessor
systems
during installation of Red Hat AS3 distribution using CDs ?

Does anyone know how I can determine if the driver was built using this
flag ?

Thanks in advance,
Frank
