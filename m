From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Initialize off value in asd_process_ctrl_a_user()
Date: Tue, 30 Dec 2014 04:04:49 -0800
Message-ID: <20141230120449.GA32187@infradead.org>
References: <1417538041-6850-1-git-send-email-emunson@akamai.com>
 <1419779536.4705.183.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1419779536.4705.183.camel@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric B Munson <emunson@akamai.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 28, 2014 at 04:12:16PM +0100, Ben Hutchings wrote:
> On Tue, 2014-12-02 at 11:34 -0500, Eric B Munson wrote:
> > If the asd_find_flash_de() function returns ENOENT the off value will
> > be used uninitialized in the call to asd_read_flash_seg().
> 
> This is just papering over the problem.  This was my attempt at a proper
> fix: http://article.gmane.org/gmane.linux.scsi/91320


That one looks much more useful to me.  Can someone give it a second
review?
