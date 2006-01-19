From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi: handle re-enable firmware message
Date: Thu, 19 Jan 2006 14:55:30 -0600
Message-ID: <20060119205530.GB21420@cs.umn.edu>
References: <20060119193444.GA21420@cs.umn.edu> <slrndsvtrd.od7.mykleb@99RXZYP.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:5285 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1161427AbWASUzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 15:55:35 -0500
Content-Disposition: inline
In-Reply-To: <slrndsvtrd.od7.mykleb@99RXZYP.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan-Frode Myklebust <mykleb@no.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2006 at 09:32:45PM +0100, Jan-Frode Myklebust wrote:
> Is there also an updated ibmvscsi-server patch somewhere? 

No, I gave up on pushing that driver in its current form towards
mainline, and I've been tied up for the last month or so on another
project.  The long term answer is to tie into the work Mike Christie &
Co. are doing....

I have somewhat reliable reports that the previous patches still work on
2.6.15.  We also have a sourcforge project with the ibmvscsis driver.
If you are using it heavily, let me know and I'll put a little more
effort into keeping it current until an alternative is available.

-- 
Dave Boutcher
