From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: single unused scsi-related CONFIG variable
Date: Fri, 26 Oct 2007 21:21:05 -0700
Message-ID: <20071026212105.c74d2f6b.rdunlap@xenotime.net>
References: <Pine.LNX.4.64.0710261417230.2937@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:47496 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750735AbXJ0EVI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Oct 2007 00:21:08 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 21:21:05 -0700
In-Reply-To: <Pine.LNX.4.64.0710261417230.2937@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-scsi@vger.kernel.org

On Fri, 26 Oct 2007 14:18:05 -0400 (EDT) Robert P. J. Day wrote:

> 
> drivers/scsi/Kconfig:1322:config SCSI_QLOGIC_FC_FIRMWARE

config SCSI_QLOGIC_FC_FIRMWARE
	bool "Include loadable firmware in driver"
	depends on SCSI_QLOGIC_FC


I don't find SCSI_QLOGIC_FC defined anywhere...

---
~Randy
