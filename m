From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi host / scsi device ref counting take 2 [1/3]
Date: Sat, 2 Aug 2003 17:50:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030802175009.A31937@infradead.org>
References: <20030801202431.GE3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:8979 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269664AbTHBQuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Aug 2003 12:50:10 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19iza5-0008JZ-00
	for linux-scsi@vger.kernel.org; Sat, 02 Aug 2003 17:50:09 +0100
Content-Disposition: inline
In-Reply-To: <20030801202431.GE3868@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, Aug 01, 2003 at 01:24:31PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2003 at 01:24:31PM -0700, Mike Anderson wrote:
> This patch set is against scsi-misc-2.5 cset 1.1595
> 
> Christoph, I am sorry I went dead on the last thread. I believe I address
> most of your issues except the name of my callback function and the sysfs
> attributes for the states. I pulled the sysfs attributes for now and
> will send later. We will need to do an update on our attributes
> interfaces due to some recent issues discovered by Mochel and Greg KH.

The patches look fine to me.

