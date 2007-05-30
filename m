From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: SMART support for SATA drives in SAS enclosures
Date: Wed, 30 May 2007 13:49:52 +0200
Message-ID: <465D64E0.6050502@macroscoop.nl>
References: <46488711.9020903@macroscoop.nl> <46549AC3.4090105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:4783 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXE3LuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 07:50:04 -0400
In-Reply-To: <46549AC3.4090105@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net

Douglas Gilbert wrote:
>
> For recent versions of smartmontools version 5.37 and
> MPT Fusion SAS HBAs this should work if /dev/sdc is
> a SATA disk. Your HBA may need a firmware upgrade.
>
>
> You might fetch sg3_utils version 1.24 and try:
>   sg_sat_identify /dev/sdc
> That needs to work before smartctl has a hope.
>   
Indeed, a firmware update made sg_sat_identify and the smartmontools
work as advertised.

Thanks,
Pim


 
