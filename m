From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI multi pathing
Date: Tue, 15 Jul 2003 11:07:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030715110727.A10381@beaverton.ibm.com>
References: <7A19797C027A6D449D68329C2A094EA0010C06C1@MUSTANG>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:30682 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269194AbTGORw0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 13:52:26 -0400
Content-Disposition: inline
In-Reply-To: <7A19797C027A6D449D68329C2A094EA0010C06C1@MUSTANG>; from JPeters@JNI.com on Tue, Jul 15, 2003 at 10:24:57AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Johnnie Peters <JPeters@JNI.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Jul 15, 2003 at 10:24:57AM -0700, Johnnie Peters wrote:
> Hi All,
> 
> I am interesting in doing multipathing for Fibre channel.  I have find the
> multipath project from IBM interesting.  It does not seem to be included in
> the 2.6-test1 kernel and the patches on their web site are pretty outdated
> now.
> 
> Is there any plans to include this in 2.6 or to keep the patches updated?
> 
> Thanks in advance for any information.

I have updated patches I plan on posting real soon now, I have it ported
and running with 2.5.74 using qlogic adapters (lastly I used the feral
driver).

There is still much todo. 

I would like to push it for inclusion in 2.7.

Hopefully we will have some good discussions at OLS next week, there is a
multi-path BOF, SCSI BOF, and a presentation on the scsi mid-level
multi-path.

-- Patrick Mansfield
