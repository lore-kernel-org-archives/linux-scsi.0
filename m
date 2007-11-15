From: Martin Peschke <mp3@de.ibm.com>
Subject: [Patch 0/2] zfcp: bug fixes for error recovery
Date: Thu, 15 Nov 2007 13:57:03 +0100
Message-ID: <1195131423.16786.31.camel@dix>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:54212 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbXKOM5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 07:57:05 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id lAFCv4Js136436
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 12:57:04 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAFCv4cd1671412
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 13:57:04 +0100
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAFCv3ZJ022695
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 13:57:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

I am posting 2 bug fixes which are required for the zfcp error recovery
to work correctly. It takes some error injection tests to strain the
zfcp error recovery to the extend which triggers both bugs. The bugs are
related to recovery actions which need to be dismissed because some
stronger action has been requested. We have verified both patches
running our error injection tests. Patches are against 2.6.24-rc2-git5.
Please apply.

[Patch 1/2] zfcp: fix dismissal of error recovery actions
[Patch 2/2] zfcp: fix cleanup of dismissed error recovery actions

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Swen Schillig <swen@vnet.ibm.com>

