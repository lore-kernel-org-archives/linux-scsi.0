From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: System freeze when accessing st.ko and /dev/st0
Date: Fri, 6 Feb 2004 12:29:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206202903.GB1488@beaverton.ibm.com>
References: <20040206194225.GA27385@mail.fortuitous.com> <4023F466.7000100@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:60670 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S265476AbUBFUXh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 15:23:37 -0500
Content-Disposition: inline
In-Reply-To: <4023F466.7000100@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: pac@fortuitous.com, linux-scsi@vger.kernel.org

Brian King [brking@us.ibm.com] wrote:
> I have been debugging this same problem in sg today. It appears as if
> kobj_unmap is never getting called when a device is deleted. When I
> added a call to kobj_unmap, the problem went away. I'm currently working
> on a patch for this.
> 
> -Brian

Are you indicating that we need a direct call to kobj_unmap along with
the call to cdev_unmap?

-andmike
--
Michael Anderson
andmike@us.ibm.com

