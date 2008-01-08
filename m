From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: multiple definition of automatic variable
 warning.
Date: Tue, 8 Jan 2008 12:57:50 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC66A@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:45247 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbYAHU5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:57:53 -0500
Received: from ADPE2K702.adaptec.com (adpe2k702.adaptec.com [10.25.8.26])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id C2F692210E4
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 12:57:52 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

The 'entry' automatic variable was defined at the top and within a block that uses it, removed the definition from the block that uses it. Some cosmetic changes were made while in the same file. This patch should be inert.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

This attached patch is against current scsi-misc-2.6.

 commctrl.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Sincerely -- Mark Salyzyn
