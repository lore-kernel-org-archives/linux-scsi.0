From: "Adrian May" <Adrian_May@Jabil.com>
Subject: SES firmward download to SAS expander
Date: Tue, 17 Mar 2009 09:49:44 +0800
Message-ID: <CCC151398C6F2B41AD8ACC06C28A779106775B32@penmsg10.corp.jabil.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corrly03.jabil.com ([192.208.44.135]:3429 "EHLO
	corrly03.jabil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZCQCDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 22:03:07 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

Some folks are asking me to advise about downloading firmware to some
SAS expander. They had this conversation with the box:

#sg_ses -s /dev/sg5
...
Download microcode (SES-2) [0xe]
...
#sg_ses --control --page=0xe --data=- /dev/sg5 < image.bin
  PMCSIERA  SXP 36x6Gsec      RevB
    enclosure services device
Setting SES control page 0xe not supported yet

What I'm trying to figure out is WHO doesn't support it: the driver or
the hardware? Is everything done by the generic linux driver or is there
some vendor-specific driver somewhere in the picture? And why would this
diag page be listed if it doesn't work? 

Huge thanks in advance for any assistance, 
Adrian.

