From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Wed, 25 Jan 2006 21:28:44 -0600
Message-ID: <20060126032844.GA16123@cs.umn.edu>
References: <1138157882.11692.31.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:42409 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751293AbWAZD2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 22:28:47 -0500
Content-Disposition: inline
In-Reply-To: <1138157882.11692.31.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2006 at 08:58:02PM -0600, Mike Christie wrote:
> The following patches begin to add the infrastructure for the SCSI
> Userspace target framework. We were not sure about what James meant by
> some of his comments, so rather than getting to far we want to post a
> for any block device (well, someone could do a libata type of target for
> any transport).

Nit question...I notice those patches are from git. Do you have a git
tree for stgt?  I was about to start figuring out subversion based on
the berlios page.

-- 
Dave Boutcher
