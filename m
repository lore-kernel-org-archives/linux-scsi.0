From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Wed, 22 Oct 2003 15:31:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022153140.A22298@infradead.org>
References: <20031021165857.A8240@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:15377 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263467AbTJVObo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 10:31:44 -0400
Content-Disposition: inline
In-Reply-To: <20031021165857.A8240@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Oct 21, 2003 at 04:58:57PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org

On Tue, Oct 21, 2003 at 04:58:57PM -0700, Patrick Mansfield wrote:
> libsysfs 0_2_0 was not installing libsysfs.h or dlist.h, manually copy
> those files to /usr/include/sys before compiling.

Umm, libsysfs isn't installing headers into /usr/include/sys, is it?
Especially with something like dlist.h that sounds like yet another
linked list implementation..

