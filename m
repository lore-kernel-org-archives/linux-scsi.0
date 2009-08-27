From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 06/64] libfc: Export FC headers
Date: Thu, 27 Aug 2009 10:42:17 -0700
Message-ID: <1251394937.3384.72.camel@fritz>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
	 <20090825205858.1553.17654.stgit@localhost.localdomain>
	 <20090827102739.GC5125@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16954 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbZH0RmW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 13:42:22 -0400
In-Reply-To: <20090827102739.GC5125@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2009-08-27 at 03:27 -0700, Christof Schmitt wrote:
> On Tue, Aug 25, 2009 at 01:58:58PM -0700, Robert Love wrote:
> > Export fc_els.h, fc_fs.h, fc_gs.h and fc_ns.h so that they
> > may be used by applications.
> > 
> > This will be needed for FC Passthrough applications like fcping,
> > but could be used by other applications.
> 
> Are there already plans to implement tools like fcping? I have heard
> people thinking about the idea, but i am not aware of a project
> working on this.
> 
Yeah, we have an implementation in our fcoe-utils package. You can
download that package here- git://open-fcoe.org/openfc/fcoe-utils.git.

//Rob

