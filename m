From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [SCSI] Make sgiwd93_detect and sgiwd93_detect static.
Date: Thu, 9 Mar 2006 15:44:11 +0000
Message-ID: <20060309154411.GA17157@linux-mips.org>
References: <20060309143513.GA11531@linux-mips.org> <20060309144415.GS7301@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:37272 "EHLO
	ftp.linux-mips.org") by vger.kernel.org with ESMTP id S1751705AbWCIPoO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 10:44:14 -0500
Received: from localhost.localdomain ([127.0.0.1]:11207 "EHLO bacchus.dhis.org")
	by ftp.linux-mips.org with ESMTP id S8133654AbWCIPfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 15:35:36 +0000
Content-Disposition: inline
In-Reply-To: <20060309144415.GS7301@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2006 at 07:44:15AM -0700, Matthew Wilcox wrote:

> Any plans to migrate sgiwd93.c away from the scsi_module.c horribleness?

I'll take a look at this.

  Ralf
