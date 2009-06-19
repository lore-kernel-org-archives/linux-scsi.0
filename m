From: "Paul Lung (paul.lung@loglogic.com)" <Paul.Lung@loglogic.com>
Subject: How To Get WWN and Device Mapping
Date: Fri, 19 Jun 2009 16:54:04 -0700
Message-ID: <D9D8963FC28A1C49BBF5EE152BE9763601278B8276@CBA0EXBE01.CBA0.centerbeam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.centerbeam.com ([64.95.134.54]:4160 "EHLO
	SMTP6.centerbeam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFTAER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2009 20:04:17 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

I'm using 2.6.25.14 kernel with the qla2xxx driver turned on for a SAN, and I tried to use SCLI from QLogic to get the linux device->wwn mapping. However, SCLI does not seem to be able to detect any LUNs with the driver in 2.6.25 kernel. I then found that doing a scsi_id on a device(say, ./block/sde)  will give me the wwn, with an extra number in the front. However, further research seems to indicate that scsi_id does not always give back the wwn. It's is totally dependent on the physical device being queried. 

So, is there any way to reliably get the WWN of a linux device? The qla2xxx driver must have gotten the wwn of all the drives on the SAN. Is this information "published" anywhere?

Thank you very much for your time.

Paul Lung