From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] qla4xxx: use pci_dev->revision
Date: Fri, 11 Feb 2011 22:49:52 +0300
Message-ID: <201102112249.52286.sshtylyov@ru.mvista.com>
References: <201102112240.59257.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:55472 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758040Ab1BKTvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2011 14:51:17 -0500
In-Reply-To: <201102112240.59257.sshtylyov@ru.mvista.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, iscsi-driver@qlogic.com

Hello.

On Friday 11 February 2011 10:40:58 pm Sergei Shtylyov wrote:

> The 'qla4xxx' driver was merged somewhat later than commit

   Hm, I got the dates wrong -- it was merged before that commit.
But without the code in question which apparently got added later
than that commit. I'll fix up the change log...

> 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all drivers to use
> pci_device->revision) and so wasn't subject to the conversion...

> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

WBR, Sergei
