From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 2.5.31] scsi_error cleanup updated
Date: Mon, 26 Aug 2002 10:46:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826174654.GB1301@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e1.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g7QHjtnM230320
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 13:45:57 -0400
Received: from dyn9-47-17-195 (dyn9-47-17-67.beaverton.ibm.com [9.47.17.67])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g7QHjtmX084654
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 11:45:55 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


I updated the scsi_error.c cleanup patch. I have added a offline device
function that was previously contained inside the scsi_eh_bus_host_reset
function. This breakup improves the readability of error policy/recovery
in the scsi_unjam_host function.

You can obtain the patch at:

http://www-124.ibm.com/storageio/gen-io/patch-scsi_error-2.5.31-1.gz

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

