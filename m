From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 11:44:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107114429.A13119@eng2.beaverton.ibm.com>
References: <hch@lst.de> <200211071550.gA7Fo9p03079@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211071550.gA7Fo9p03079@localhost.localdomain>; from James.Bottomley@steeleye.com on Thu, Nov 07, 2002 at 10:50:08AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Anderson <andmike@us.ibm.com>, "Adam J. Richter" <adam@yggdrasil.com>, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 10:50:08AM -0500, J.E.J. Bottomley wrote:
> hch@lst.de said:

> There are other nasties waiting in the pipeline.  The one that's been 
> bothering me is the SCSI3 Controller Commands (for arrays and the like).  This 
> basically adds array controller information to a standard direct-access 
> device, but crucially, it has two different (and incompatible with 
> direct-access) ways of addressing the array: physical-by real disk and 
> logical-by the actual RAID-n unit.

The SCSI Enclosure Services also allows similiar behaviour (I haven't
looked at the latest SES specs).

It would be nice if these device added another LUN for the SCC or
SES controller access.

-- Patrick Mansfield
