From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Why is the kernel complaining about large SCSI LUNs
Date: Fri, 7 Jan 2005 17:59:11 -0700
Message-ID: <91888D455306F94EBD4D168954A9457CC6F674@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23023 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261692AbVAHA70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 19:59:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurice Volaski <mvolaski@aecom.yu.edu>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

> Is there a way I could get more information? Does the MPT driver have 
> a debug/verbose capability?

Yes, debug printk's can be enabled by recompiling the
driver.  Look in the Makefile for what to uncomment and enable,
then also refer to mptbase.h for various  MPT_DEBUG_XXX defines.

Eric Moore

