From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [BUG] 2.6.0-test4: call of slave_destroy missing
Date: Tue, 2 Sep 2003 14:16:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309021416.44765.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-2.de.ibm.com ([194.196.100.235]:53247 "EHLO
	d12lmsgate.de.ibm.com") by vger.kernel.org with ESMTP
	id S261331AbTIBMQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2003 08:16:13 -0400
Received: from d12relay01.megacenter.de.ibm.com (d12relay01.megacenter.de.ibm.com [9.149.165.180])
	by d12lmsgate.de.ibm.com (8.12.9/8.12.8) with ESMTP id h82CG4EF194794
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2003 14:16:04 +0200
Received: from osiris (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay01.megacenter.de.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h82CGCWa259506
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2003 14:16:12 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

the upgrade diff from test3 to test4 removed the call of slave_destroy from
scsi_free_sdev, but didn't add it at any other place (scsi_remove_device?).
So currently of the alloc/destroy pair just the alloc call happens... I'm
not sure where the destroy call should be and therefore leave it to somebody
else to fix this :)

regards,
Heiko

