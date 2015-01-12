From: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Subject: RE: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Mon, 12 Jan 2015 23:05:03 +0000
Message-ID: <5c5aa6a1-3ab9-4f4b-88c6-3ffe4dd0c342@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:36615 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbALXFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 18:05:14 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>
Cc: "Mike Christie (michaelc@cs.wisc.edu)" <michaelc@cs.wisc.edu>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>


>From: Minh Duc Tran 
>Sent: Sunday, November 09, 2014 10:52 PM
>To: 'linux-scsi@vger.kernel.org'
>Cc: Mike Christie (michaelc@cs.wisc.edu); Jayamohan Kallickal
>Subject: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag

>From: Minh Tran minhduc.tran@emulex.com

>               We are starting to see problems with certain open-iscsi versions out there checking block valid bit.  Iscsi boot target login will not happen without this bit being set.

>Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
>---
>scsi/be2iscsi/be_main.c |    4 ++--
>1 files changed, 2 insertions(+), 2 deletions(-)

>diff --git a/scsi/be2iscsi/be_main.c b/scsi/be2iscsi/be_main.c
>index 30d74a0..aacf223 100644
>--- a/scsi/be2iscsi/be_main.c
>+++ b/scsi/be2iscsi/be_main.c
>@@ -429,7 +429,7 @@ static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
>                             auth_data.chap.intr_secret);
>                break;
>        case ISCSI_BOOT_TGT_FLAGS:
>-               rc = sprintf(str, "2\n");
>+               rc = sprintf(str, "3\n");
>                break;
>        case ISCSI_BOOT_TGT_NIC_ASSOC:
>                rc = sprintf(str, "0\n");
>@@ -466,7 +466,7 @@ static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)

>        switch (type) {
>        case ISCSI_BOOT_ETH_FLAGS:
>-               rc = sprintf(str, "2\n");
>+               rc = sprintf(str, "3\n");
>                break;
>        case ISCSI_BOOT_ETH_INDEX:
>                rc = sprintf(str, "0\n");
>--
>1.7.1

Hi Mike,
I think we have lost track of this patch.  I've checked 3.19-rc3 today and it's not in yet.  Can we get this in as soon as possible?

Thanks.
-Minh

(Removed html format, sorry about that)
