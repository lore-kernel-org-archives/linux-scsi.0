From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 0/6] mpt fusion: Patch set for updating MPT fusion drivers
Date: Wed, 21 May 2008 00:53:44 +0530
Message-ID: <20080520192343.GA11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42272 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbYETTcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 15:32:23 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m4KJSbgP019495
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 12:28:37 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

This patch set contains the following patches for MPT Fusion drivers

[PATCH 1/6] : MPT Fusion driver version upgrade to 3.04.07
[PATCH 2/6] : Updated copyright statment with 2008 included
[PATCH 3/6] : Fixing default enabling of MSI for SPI and FC controllers
[PATCH 4/6] : Fixing 1078 data corruption issue for 36GB memory region resubmitted with review suggestions included
[PATCH 5/6] : Setting intial period to 0xFF instead of 0xA
[PATCH 6/6] : Adding FAULT Reset work



