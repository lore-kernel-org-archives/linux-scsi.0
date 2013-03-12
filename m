From: jayamohank@gmail.com
Subject: be2iscsi: set of patches for be2iscsi
Date: Mon, 11 Mar 2013 21:39:46 -0700
Message-ID: <1363063186-4902-16-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56355 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab3CLEkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:22 -0400
Received: by mail-pb0-f42.google.com with SMTP id xb4so4550166pbc.29
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:22 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

Hi James

These patches contains updates for the be2iscsi driver
cut against scsi.git, branch "misc"

The patcheset for 10.0.442.0 includes
	- Fix lack of uninitialize pattern to FW
	- Fix returning Failure when MBX has insufficient Buffer
	- Fix MBX Command issues
	- Fix MSIx support in SKH R to 32
	- Fix freeing CXN specific driver resources
	- Fix MACRO for checking the adapter type
	- Fix support for DEFQ extension
	- Fix displaying the FW Version from driver
	- ix displaying the Active Session Count from driver
	- Fix the Port Link Status issue
	- Fix the NOP In handling code path
	- Fix dynamic CID allocation Mechanism in driver
	- Fix checking Adapter state while establish a connection
	- Fix the copyright information
	- Bump the driver version

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
