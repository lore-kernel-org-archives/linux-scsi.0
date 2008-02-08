From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] aacraid: add optional MSI support.
Date: Thu, 07 Feb 2008 18:30:34 -0600
Message-ID: <1202430634.3171.41.camel@localhost.localdomain>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D643D@ADPE2K703.adaptec.com>
	 <20080205234912B.tomof@acm.org>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4397D6932@ADPE2K703.adaptec.com>
	 <20080206101148L.fujita.tomonori@lab.ntt.co.jp>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
	 <1202320497.3112.92.camel@localhost.localdomain>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F43982A010@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49961 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762382AbYBHAai (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 19:30:38 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F43982A010@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


On Wed, 2008-02-06 at 13:20 -0800, Salyzyn, Mark wrote:
> Added support for MSI utilizing the aacraid.msi=1 parameter. This patch adds some localized or like-minded janitor fixes. Since the default is disabled, there is no impact on the code paths unless the customer wishes to experiment with the MSI performance.
> 
> This patch is against current scsi-misc-2.6

It doesn't seem to compile:

drivers/scsi/aacraid/sa.c: In function 'aac_sa_init':
drivers/scsi/aacraid/sa.c:388: error: dereferencing pointer to incomplete type
drivers/scsi/aacraid/sa.c:406: error: dereferencing pointer to incomplete type

It looks like this can be corrected by #include <linux/pci.h> since it's
struct pci_dev that's the incomplete type.

James


