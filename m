From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Mon, 19 Jan 2004 19:35:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119193509.A4906@infradead.org>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <20040119193354.GC967@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:49933 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262705AbUASTfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 14:35:10 -0500
Content-Disposition: inline
In-Reply-To: <20040119193354.GC967@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Jan 19, 2004 at 11:33:54AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Jan 19, 2004 at 11:33:54AM -0800, Mike Anderson wrote:
> This is my fault. We recommended not to include procfs info in this
> driver and pointed to sysfs. Do we have a timeline on MODULE_VERSION?

Ask rusty, he's been pushing for this for a while.

