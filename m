From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 3/4] qla1280,qla2xxx: Remove display of transfersize
Date: Thu, 18 Oct 2007 11:57:33 -0700
Message-ID: <4717AC9D.4040000@qlogic.com>
References: <11927248762034-git-send-email-matthew@wil.cx> <11927248763320-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:17922 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbXJRS4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 14:56:16 -0400
In-Reply-To: <11927248763320-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> As part of their debug routines, both of these drivers print out the
> transfersize.  That's just unnecessary, particularly since neither driver
> actually uses it.
NACK for qla2xxx - I would rather change it to 'cmd->device->sector_size' instead of removing it.
A patch will be followed by.

Thank you,
Seokmann

