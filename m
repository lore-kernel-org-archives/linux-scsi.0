From: James Smart <James.Smart@Emulex.Com>
Subject: Re: scsi/lpfc/lpfc_attr.c: bogus code
Date: Wed, 12 Dec 2007 17:00:29 -0500
Message-ID: <476059FD.2070300@emulex.com>
References: <20071211222055.GE14204@stusta.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60482 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXLLWBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 17:01:12 -0500
In-Reply-To: <20071211222055.GE14204@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This has already been fixed. It's in our 8.2.3 patches, which were merged into
James's scsi-misc-2.6 tree at the beginning of November, and targeted for 2.6.25.

-- james s


Adrian Bunk wrote:
> Commit 2e0fef85e098f6794956b8b80b111179fbb4cbb7 added the folowing code 
> to drivers/scsi/lpfc/lpfc_attr.c that was most likely not intended to be 
> dead code:
> 
> <--  snip  -->
> 
> ...
> lpfc_state_show(struct class_device *cdev, char *buf)
> {
> ...
>                 switch (vport->port_state) {
>                         len += snprintf(buf + len, PAGE_SIZE-len,
>                                         "initializing\n");
>                         break;
> ...
> 
> <--  snip  -->
> 
> Spotted by the GNU C compiler version 3.3.
> 
> cu
> Adrian
> 
