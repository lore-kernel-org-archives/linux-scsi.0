From: "Stephens, Larry" <larry.stephens@lsil.com>
Subject: scsi_transport_spi.c
Date: Mon, 10 Jan 2005 14:07:14 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C2023B3@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26784 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262546AbVAJVHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 16:07:16 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j0AL59cq025973
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 13:05:09 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j0AL7EsG004982
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 13:07:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I'm in the initial stages of looking at modifying the LSI driver to utilize
the Domain Validation code in scsi_transport_spi.c rather than our own
driver DV code.

I've installed RHEL 4.  Where can I obtain the kernel source file for kernel
2.6.9-1.906_ELsmp, containing scsi_transport_spi.c?

Thanks in advance.
