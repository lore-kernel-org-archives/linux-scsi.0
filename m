From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: PATCH] [ConfigFS]: Extend CONFIGFS_ATTR_STRUCT() and
	CONFIGFS_ATTR_OPS() macros
Date: Wed, 22 Oct 2008 15:13:58 -0700
Message-ID: <20081022221358.GA7621@mail.oracle.com>
References: <1224713189.24358.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:16528 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbYJVWPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 18:15:31 -0400
Content-Disposition: inline
In-Reply-To: <1224713189.24358.111.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Wed, Oct 22, 2008 at 03:06:29PM -0700, Nicholas A. Bellinger wrote:
> Hi Joel,
> 
> What do you think..?
> 
> Also, here is the drivers/lio-core/iscsi_target_configfs.c commit to
> convert to use to new parameters for CONFIGFS_ATTR_STRUCT() and
> CONFIGFS_ATTR_OPS():

	It seems even more complex, and inconsistent with what sysfs
and other users do.  Can you give me an example of using it?

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
