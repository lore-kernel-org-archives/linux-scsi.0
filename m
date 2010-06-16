From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/9] hpsa: add new controllers
Date: Wed, 16 Jun 2010 13:51:15 -0500
Message-ID: <20100616185115.22798.33905.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23948 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759027Ab0FPSqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:16 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: add new controllers

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1133b5f..ec9b3a2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -86,6 +86,11 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
 #define PCI_DEVICE_ID_HP_CISSF 0x333f
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
@@ -109,6 +114,11 @@ static struct board_type products[] = {
 	{0x324b103C, "Smart Array P711m", &SA5_access},
 	{0x3233103C, "StorageWorks P1210m", &SA5_access},
 	{0x333F103C, "StorageWorks P1210m", &SA5_access},
+	{0x3250103C, "Smart Array", &SA5_access},
+	{0x3250113C, "Smart Array", &SA5_access},
+	{0x3250123C, "Smart Array", &SA5_access},
+	{0x3250133C, "Smart Array", &SA5_access},
+	{0x3250143C, "Smart Array", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 

