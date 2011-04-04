From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [GIT] isci: update for 4/1
Date: Mon, 4 Apr 2011 07:35:57 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D5048A9C52A9@azsmsx504.amr.corp.intel.com>
References: <1301194067.28442.22.camel@dwillia2-linux>
 <1301706950.1429.9.camel@dwillia2-linux>
 <20110402121644.GC30913@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40203 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab1DDOf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2011 10:35:59 -0400
In-Reply-To: <20110402121644.GC30913@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Saturday, April 02, 2011 5:17 AM
> To: Williams, Dan J
> Cc: linux-scsi; David Milburn; Jiang, Dave; Ciechanowski, Ed; Nadolski,
> Edmund; Danecki, Jacek; hch@infradead.org; Skirvin, Jeffrey D
> Subject: Re: [GIT] isci: update for 4/1
> 
> On Fri, Apr 01, 2011 at 06:15:50PM -0700, Dan Williams wrote:
> > isci.git has been updated with bug fixes around error handling and
> > cleanups driven by the ongoing review, details below.  The patches
> > that have not appeared on the mailing list are included inline.
> 
> BTW, what the plan for the STP packet command code?  It's ifdef out in a
> rather ugly way and already starting to bitrot.  Unless you plan to resurrect it
> real soon I think we're better off removing it entirely for now.

I think this will have to be removed for this go around. It is one of the features that has been moved to target 2.6.40. 

