From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Sun, 27 Mar 2011 18:32:56 -0400
Message-ID: <20110327223256.GB7487@infradead.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1C0Wc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2011 18:32:58 -0400
Content-Disposition: inline
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Btw, the naming scheme in the driver seems utterly confusing,
with prefixed split between isci_, sci_ and scic_, where a lot of
the latter also have a second sds_ or controller_ prefix.  Especially
the use of controller_ in a lot of the nomenclature seems very
confusing to me.  Is there a scheme behind all this?

