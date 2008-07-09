From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Target drivers for QLogic Fibre Channel cards released
Date: Wed, 09 Jul 2008 11:00:41 +0400
Message-ID: <48746219.6050104@vlnb.net>
References: <4873BCD5.5060407@vlnb.net> <4873C6EB.9080207@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:38790 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640AbYGIHAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 03:00:00 -0400
In-Reply-To: <4873C6EB.9080207@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

Jeff Garzik wrote:
> Vladislav Bolkhovitin wrote:
>> I'm glad to announce that version 1.0.0 of target drivers for QLogic 
>> Fibre Channel cards released and available for download from 
>> http://scst.sourceforge.net/downloads.html.
>>
>> Two target drivers were released:
>>
>>   - Target driver qla2x00t for 22xx and 23xx based QLogic Fibre Channel 
>> cards
>>
>>   - Target driver qla_isp for 24xx based QLogic Fibre Channel cards
>>
>> Those drivers are designed to work in SCST environment. They are high 
>> performance drivers, which provide all necessary functionality to work 
>> as targets in Fibre Channel environment.
>>
>> Detail description of the target drivers you can find on SCST home page 
>> http://scst.sourceforge.net.
>>
>> Driver qla2x00t is being prepared in form of patch for review and 
>> inclusion into the kernel.
> 
> Cool.  I'm looking forward to figuring out how to enable ATA target mode 
> in a similar manner...  sata_mv and some ahci chips support ATA target mode.

Actually, I forgot to mention that there are two more target drivers 
available for download as well. One of them can be especially interested 
for you, because it should work with SAS (I have a report with coming 
CDBs from this transport, but have no hardware to check).

  - Target driver for InfiniBand SRP 
http://scst.sourceforge.net/target_srp.html

  - Target driver for LSI/MPT cards 
http://scst.sourceforge.net/target_lsi.html. This driver was developed 
for parallel SCSI, but also should work with SAS and Fibre Channel 
transports.

They can be downloaded from the SCST SVN by using command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst

They were not released as a separate packages, because their authors 
preferred that.

Vlad
