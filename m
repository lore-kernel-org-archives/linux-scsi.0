From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mptfusion - fc transport attributes - REVISED
Date: Fri, 13 Jan 2006 18:22:20 +0000
Message-ID: <20060113182220.GA21431@infradead.org>
References: <43C6E06D.7090609@sgi.com> <20060113103106.GA11553@infradead.org> <43C7EEDB.3010802@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29388 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422800AbWAMSWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:22:21 -0500
Content-Disposition: inline
In-Reply-To: <43C7EEDB.3010802@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Hickerson, Roger" <roger.hickerson@lsil.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

> This driver is full of lines longer than 80 characters....  I'll see what I can
> do.  I'm not planning on reworking the entire driver to shorten the line lengths
> but if there are obvious places in my patch, like above, I'll do what I can to
> conform.

sure, no need to fix up existing code - just don't introduce new ones.

> I suspect it should be a separate patch to clean up all the white space / style/long line / other issues in this driver.  :)

yeah, small cleanup patches are always nice, just don't mix them up with
real bugfixes or new features.

> > 	Please try to order functions so that forward-prototypes aren't
> > 	needed.  (where easily possible)
> 
> In this case, most references are needed for the scsi_host_template
> or the fc_function_template and I'm chosing to not move those function
> templates.

ok

> > 	could you calls this ioc->fc_rescan_work?  also no need for the
> > 	void cast.
> 
> I had intended to create a "generic" work_task structure that could be
> used by all personalities of the driver as, AFAIK, only one will
> own an hba.  However, I understand the point and will change it.  If
> this is important enough to me, I can make it a union later once the
> dust settles.

ok.

> I looked at your patch to mptsas for slave_destroy.  I believe that since the
> fc_transport retains rport info for the case when the rport returns
> after destroy, that mptfc should retain its data structure.

indeed, that makes sense.

> scsi_scan_host was a delete, not an insert point....

sorry, looks like I misread the patch.

