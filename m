From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
Date: Tue, 22 May 2012 12:10:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205221209530.2100-100000@iolanthe.rowland.org>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> Hi,
> 
> In August 2010, Jens and Alan discussed about "Runtime PM and the block
> layer". http://marc.info/?t=128259108400001&r=1&w=2
> 
> Here are the RFC v3 patches that try to implement the ideas discussed.
> Welcome to give it a try.

Have you checked to make sure these changes won't break the IDE driver?  
Maybe it will need to set the REQ_PM flag too.

Alan Stern
