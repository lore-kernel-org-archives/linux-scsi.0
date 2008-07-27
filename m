From: James Bottomley <jejb@kernel.org>
Subject: Patch added to scsi-misc-2.6:  [SCSI] replace __FUNCTION__ with __func__
Date: Sun, 27 Jul 2008 14:39:41 GMT
Message-ID: <200807271439.m6REdf1i017665@hera.kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbYG0Ojs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2008 10:39:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Harvey Harrison <harvey.harrison@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI List <linux-scsi@vger.kernel.org>

Your commit:

    [SCSI] replace __FUNCTION__ with __func__
    
    [jejb: fixed up a ton of missed conversions.
    
     All of you are on notice this has happened, driver trees will now
     need to be rebased]
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Cc: SCSI List <linux-scsi@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

has been added to the upstream SCSI tree
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=cadbd4a5e36dde7e6c49b587b2c419103c0b7218

This patch is scheduled to be pushed when the merge window opens for 2.6.27

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
