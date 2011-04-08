From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH, RFC] isci: remove scic_controller state handlers
Date: Fri, 8 Apr 2011 10:47:05 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D5048AAD5AEA@azsmsx504.amr.corp.intel.com>
References: <20110402121520.GB30913@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57093 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab1DHRrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2011 13:47:12 -0400
In-Reply-To: <20110402121520.GB30913@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Saturday, April 02, 2011 5:15 AM
> To: Williams, Dan J
> Cc: linux-scsi; David Milburn; Jiang, Dave; Ciechanowski, Ed; Nadolski,
> Edmund; Danecki, Jacek; Skirvin, Jeffrey D
> Subject: [PATCH, RFC] isci: remove scic_controller state handlers
> 
> Remove the state handler indirections for the scic_controller, and replace
> them with procedural calls that check for the correct state first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied
