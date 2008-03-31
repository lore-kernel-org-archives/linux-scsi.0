From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/9] zfcp: Cleanup code in debug trace.
Date: Mon, 31 Mar 2008 11:15:22 +0200
Message-ID: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:28575 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYCaJSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

After updating the contents of the zfcp debug trace in the last patch
series, simplify the code, add docbook style description for the
interface and move the definitions for the zfcp debug trace to a new
header file.

Patches apply to current scsi-misc.

Christof
