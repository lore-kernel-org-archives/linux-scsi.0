From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi_scan.c question
Date: Fri, 18 Oct 2002 08:57:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021018085754.A474@eng2.beaverton.ibm.com>
References: <20021016213518.GE8159@redhat.com> <20021016145728.A6657@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9IFvu1q038850
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2002 11:57:56 -0400
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9IFvtgh028846
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2002 09:57:56 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id g9IFtI832235
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2002 08:55:18 -0700
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g9IFvsm00561
	for linux-scsi@vger.kernel.org; Fri, 18 Oct 2002 08:57:54 -0700 (PDT)
In-Reply-To: <20021016145728.A6657@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Oct 16, 2002 at 02:57:28PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Oct 16, 2002 at 02:57:28PM -0700, Patrick Mansfield wrote:
> On Wed, Oct 16, 2002 at 05:35:18PM -0400, Doug Ledford wrote:
> > Is anyone still working on this code or have the changes other people 
> > wanted to make all been integrated?
> 
> Not that I know of.

Sorry, I did not include SCSI-2 LUN setting changes for scsi_scan.c in
my recent consolidate SCSI-2 command lun setting patch, I re-rolled the
patch with scsi_scan.c changes, and I'm asking James to push it.

Also, I was excluding my multi-path changes - I'm assuming I'll have to
merge with whatever changes you make.

-- Patrick Mansfield
