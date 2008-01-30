From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Wed, 30 Jan 2008 11:29:47 -0800
Message-ID: <20080130192947.GA21785@tree.beaverton.ibm.com>
References: <479FB3ED.3080401@hopnet.net> <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46999 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYA3T3y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 14:29:54 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0UJVfY9022151
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 14:31:41 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0UJTmCT456228
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 14:29:48 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0UJTm8Z006419
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 14:29:48 -0500
Content-Disposition: inline
In-Reply-To: <47A05896.40900@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <vger@hopnet.net>
Cc: Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On Wed, Jan 30, 2008 at 06:59:34PM +0800, Keith Hopkins wrote:
> 
> V28.  My controller functions well with a single drive (low-medium load).  Unfortunately, all attempts to get the mirrors in sync fail and usually hang the whole box.

Adaptec posted a V30 sequencer on their website; does that fix the
problems?

http://www.adaptec.com/en-US/speed/scsi/linux/aic94xx-seq-30-1_tar_gz.htm

--D
