From: Matt Mackall <mpm@selenic.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Wed, 9 Mar 2005 11:41:12 -0800
Message-ID: <20050309194112.GZ3120@waste.org>
References: <422E96D9.6090202@yahoo.com> <OF44130B14.D1B3F38E-ON85256FBF.0068AD48-88256FBF.006AACD8@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from waste.org ([216.27.176.166]:455 "EHLO waste.org")
	by vger.kernel.org with ESMTP id S261199AbVCITl0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 14:41:26 -0500
Content-Disposition: inline
In-Reply-To: <OF44130B14.D1B3F38E-ON85256FBF.0068AD48-88256FBF.006AACD8@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Alex Aizman <itn780@yahoo.com>, linux-scsi@vger.kernel.org

On Wed, Mar 09, 2005 at 11:29:03AM -0800, Bryan Henderson wrote:
> I'd like to remind everyone that user space processes aside, there's still 
> a basic ISCSI initiator resource inversion that needs to be fixed to avoid 
> deadlock:
> 
> ISCSI initiator driver sits below the memory pool
>   (I..e a pageout involving ISCSI might be prerequisite to getting memory)
> Socket layer sits below ISCSI
>   (ISCSI initiator driver relies on socket services)
> Memory pool sits below socket layer
>   (socket layer allocates memory from the main pool)
> 
> One might say as long as that's there, close is good enough on the user 
> space initiator component.

This issue is becoming increasingly pressing and hopefully there'll be
a plan for addressing it soon. Unfortunately, none of the proposed
solutions help the userspace inversion problem.

-- 
Mathematics is the supreme nostalgia of our time.
