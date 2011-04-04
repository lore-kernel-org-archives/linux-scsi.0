From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] cmd->serial_number removal, part 1
Date: Mon, 4 Apr 2011 09:42:03 -0400
Message-ID: <20110404134203.GA29525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1DDNmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2011 09:42:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

This removes all the east users of the command serial number.  After
this we still have dpt_i2o, which uses the serial number for finding
commands in it's completion handler, and the eata and u14-34f drivers
which use it for their own elevator algorithms.
