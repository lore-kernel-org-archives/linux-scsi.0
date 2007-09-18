From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: kdump detection in SCSI drivers
Date: Tue, 18 Sep 2007 15:39:28 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61400 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXIRVja convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 17:39:30 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

Is there a standard way for drivers (RAID) to detect if the current
kernel is running in kdump mode? We would like to adjust driver behavior
dynamically when kdump is active by scaling down resources.

Thanks
-Atul Mukker
LSI Corp.
