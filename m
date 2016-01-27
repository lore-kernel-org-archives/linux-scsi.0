From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: UFS Help: OCS is returning invalid (0x7)
Date: Wed, 27 Jan 2016 16:58:23 +0000
Message-ID: <56A8F72F.40302@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:54987 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbcA0Q62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2016 11:58:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akinobu.mita@gmail.com, hch@infradead.org, ygardi@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, Carlos Palminha <CARLOS.PALMINHA@synopsys.com>

Hi!
I am currently working in the implementation of DesignWare Quirks in the
existing UFS core and implementing a glue platform driver.
The project status is the following:

- Synopsys MPHY Test Chip is well configured
- Link is up in Host & Device (validated through the 0xd083 register)
- Additional connection setup are made successfully
- HBA is operational
- NOP_OUT is failing with OCS = 0x7

The OCS value is calculated in ufshcd_get_tr_ocs() in ufshcd.c.
I made a dump of the UTRD pointer where we can check the status = 7 ([2]).

UTRD at: 7007c3e0
@0000 [0]:21000000
@0004 [1]:93936a6a
@0008 [2]:00000007
@000c [3]:93936a6a
@0010 [4]:9f317400
@0014 [5]:00000000
@0018 [6]:00800080
@001c [7]:01006a6a

Did anyone have the same problem? Any hints to overcome this issue?

Thank you very much for your help!

Joao
