From: "Ken Hwang" <ken.hwang@zyxel.com>
Subject: SG_IO ioctl
Date: Thu, 21 Dec 2006 14:11:54 -0800
Message-ID: <HIENIDNHFMODBIPFNJPDGEHFDOAA.ken.hwang@zyxel.com>
Reply-To: <ken.hwang@zyxel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:21154 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423120AbWLUWS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Dec 2006 17:18:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I had a utility which uses SG_IO ioctl (scsi passthrough?) to issue private
commands to a USB dongle (reported as a USB Mass Storage but with 0 bytes)
to get some information back. It works fine with kernel 2.6.12.2. But after
we upgraded to kernel 2.6.15.4 then the program could not get information
back anymore (reads all 0 with the private command). Can anyone please give
me a hint of where I should go studying more?

Thanks,

Ken
--
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.409 / Virus Database: 268.15.26/594 - Release Date: 12/20/2006

