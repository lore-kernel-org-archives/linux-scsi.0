From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: Problems with MSI-X on ia64
Date: Fri, 17 Feb 2006 11:52:45 -0800
Message-ID: <B8E391BBE9FE384DAA4C5C003888BE6F05BF610F@scsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr23.intel.com ([143.183.121.15]:63155 "EHLO
	scsfmr003.sc.intel.com") by vger.kernel.org with ESMTP
	id S1751417AbWBQTx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2006 14:53:29 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wedgwood <cw@f00f.org>, Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>

> Hrm, it may be doing this.  I wonder how that works though with 4GB's
> of RAM installed?

Systems with 4G of RAM usually map part of the RAM above 4G so as to
leave a hole for i/o mapping etc.

-Tony
