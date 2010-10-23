From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Sat, 23 Oct 2010 11:58:16 +0200
Message-ID: <20101023095816.GA19791@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:44092 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab0JWO6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2010 10:58:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

On a Dell PowerEdge 2900 III I have a PERC6/i (MegaRaid SAS 1078). From
the controller bios is seems I have to create a "raid0 virtual drive"
for each physical disk or in order for them to appear in Linux.

As I intend to use none of that controller's raid features, is it at all
possible to switch it to plain JBOD mode?

Thanks,
