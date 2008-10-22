From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
Date: Wed, 22 Oct 2008 19:31:11 +0200
Message-ID: <48FF635F.8060207@panasas.com>
References: <4B6A08C587958942AA3002690DD4F8C32D2C5EFE@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:20951 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752328AbYJVRbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 13:31:25 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C32D2C5EFE@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "pterjan@gmail.com" <pterjan@gmail.com>, "matthew@wil.cx" <matthew@wil.cx>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Yang, Bo wrote:
> Thanks Boaz, the name for SAS is megaraid_sas and MPT is fusion.
> 
> Regards,
> 
> Bo Yang
> 

I have also reviewed megaraid_mbox.c and megaraid_mm.c. and all files
in drivers/message/fusion/* (See other mail for megaraid_sas.c).
I do not see any problems with these drivers. They do not allocate
private scsi_cmnd structures.

Anything else to review?

Thanks
Boaz
