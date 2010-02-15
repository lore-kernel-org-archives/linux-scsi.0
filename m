From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: [RFC]: new LSI MegaRAID driver implementation
Date: Mon, 15 Feb 2010 10:09:23 -0700
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:57307 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab0BORan convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2010 12:30:43 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

We (LSI MegaRAID team) are working on enhancing the functionality of the MegaRAID driver. These enhancements include support for next generation HBAs.

The new generation HBA interface would be significant different than the current interface. There would not be any changes for raid management application driver interfaces though.

We are anticipating about 70-80% of the current driver code to be changed. These changes would not be functional in nature though. The current functionality would be re-aligned in supporting functions. A parallel stream of functions would be created to support new HBAs.

We are not anticipating changes in ways the new driver would work with the current generation of the HBAs and therefore we do not foresee any impact on the current functionality for these HBAs.

We would like to solicit community feedback if this approach is acceptable. Alternative would be to leave the current driver untouched and submit a new driver for next generation of HBAs.

Your inputs would be highly appreciated.

Regards,

Atul Mukker
LSI Corp.