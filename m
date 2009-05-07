From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset 0/6] osd changes  for 2.6.31
Date: Thu, 07 May 2009 18:18:57 +0300
Message-ID: <4A02FBE1.4000406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:32254 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757260AbZEGPTG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 11:19:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Hi James

I'm sending some patches that have accumulated for the next merge window.
If they could sit in scsi-misc (and linux-next).

On top of these I will later send a couple of patches for
getting rid of the use of blk_rq_append_bio, as well as
support for chained-bios for Jeff's pending osdblk driver.
These should go in first, as the "other work" is rebased ontop
of these here.

These are the list of patches:

[PATCH 01/6] libosd: OSD2r05: Additional command enums
[PATCH 02/6] libosd: OSD2r05: Attribute definitions  
[PATCH 03/6] libosd: Better printout of OSD target system information

  These are just small stuff that have been added after the last merge window

[PATCH 04/6] libosd: osd_req_{read,write}_kern new API
  This is refactoring of common code used by a few library users

[PATCH 05/6] libosd: Let _osd_req_finalize_data_integrity receive number of out_bytes
[PATCH 06/6] libosd: osd_req_{read,write} takes a length parameter
  These patches are in preparation for supporting bio-chains. BIO-chains support is
  needed both by Jeff's osdblk stacking block device, as well as future work in exofs
  and pNFS-Objects layout-driver.

  The support is not yet finished until acceptance of a couple of patches to the block
  layer and corresponding patches to osd which I will send next.

Thank you in advance
Boaz
