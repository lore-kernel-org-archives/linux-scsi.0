From: Christoph Hellwig <hch@infradead.org>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 18:58:26 +0100
Message-ID: <20060428175826.GA18373@infradead.org>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16098 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751426AbWD1R62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:58:28 -0400
Content-Disposition: inline
In-Reply-To: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

more comments on the actual aic94xx driver:

 - the README file wouldn't contain much anymore after the outdated
   bits are removed, I'd suggest killing it and listing the supported
   hardware in the Kconfig instead
 - lots of inline abuse that should go away
 - please use the pci_iomap api to support pio and mmio transparently
   instead of the local wrappers
 - no need to handle signle-element SG lists anymore
 - CLEAR_NEXUS_PRE and CLEAR_NEXUS_POST should become real functions instead
   of context-sensitive macros
 - what about replacing ASD_DPRINTK with the standard debugging helpers?
