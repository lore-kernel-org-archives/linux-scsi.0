From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: Fix for problems introduced by enabling MSI by default for MPT SPI
 controllers
Date: Wed, 9 Jul 2008 14:54:32 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72239@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58200 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYGIGyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 02:54:43 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m696oVg1011974
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 23:50:31 -0700 (PDT)
Received: from PALHUB01.lsi.com (palhub01.lsi.com [128.94.213.114])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id m696sg4p002721
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 23:54:42 -0700
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>

Recently there are some issues posted in the list with regards to failure of booting or failure of driver loading  when the MSI is enabled by default for MPT SPI controllers.

James has already provided the patch for fixing the panic.

But the reason for IOC bring up failure is enabling the MSI by default for SPI controllers.  The issue is introduced by the following patch. Which is intended for enabling the MSI only for SAS controllers but enables MSI for SPI, FC and SAS controllers.
http://marc.info/?l=linux-scsi&m=120488594802569&w=4

I have already posted another patch to rectify this so that MSI will not be enabled by default for SPI and FC controllers. The link for the correction patch is as below.
http://marc.info/?l=linux-scsi&m=121131228827682&w=4

Thanks
Sathya

