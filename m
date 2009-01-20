From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: swiotlb default size (64 MB) too small?
Date: Tue, 20 Jan 2009 21:10:48 +0100
Message-ID: <49762FC8.7000208@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45628 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300AbZATUK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 15:10:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,

somebody reported frequent "Out of SW-IOMMU space" failures when copying
between a FireWire and a USB disk.  swiotlb=512M on the kernel command
line fixes it for him. https://bugzilla.redhat.com/show_bug.cgi?id=478567

Should the default be raised?
-- 
Stefan Richter
-=====-==--= ---= =-=--
http://arcgraph.de/sr/
