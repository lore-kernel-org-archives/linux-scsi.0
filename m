From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI kobject unregistration ordering problem
Date: Fri, 17 Oct 2003 13:34:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017133429.C27349@infradead.org>
References: <20031013151254.521d882e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:49159 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263435AbTJQMec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:34:32 -0400
Content-Disposition: inline
In-Reply-To: <20031013151254.521d882e.akpm@osdl.org>; from akpm@osdl.org on Mon, Oct 13, 2003 at 03:12:54PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Andrey Borzenkov <arvidjaar@mail.ru>

On Mon, Oct 13, 2003 at 03:12:54PM -0700, Andrew Morton wrote:
> So it looks like SCSI needs fixing.  Could someone please take care of this?
> Thanks.

This needs fixing deeper down in the block layer and Al is working on
that.  Once the block layer has sane semantics for device_del vs partitions
scsi can be fixed trivially.

