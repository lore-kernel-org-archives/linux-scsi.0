From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Data accessors more patches
Date: Wed, 04 Jul 2007 21:19:58 +0300
Message-ID: <468BE4CE.80402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:46922 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755048AbXGDSUH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 14:20:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

As a reply to this email I will send some more files
converted to new data accessors, and attempts of cleanups
of: !use_sg code path's, use of scsi_for_each_sg and use
of scsi_{,un}map_dma().

some of these files are in scsi-ml core but they can be converted
now, and are not at all dependent on implementation.

libata-scsi.c	- code will now work with scsi_sgtable but farther cleanup is needed.
scsi.c 		- some prints might as well use accessors now.
scsi_debug.c	- This is actually a scsi LLD. Normal conversion.

The rest of the converted files I will send in the following days

Boaz

