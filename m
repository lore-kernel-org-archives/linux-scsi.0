From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 25 Nov 2003 08:18:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125081818.A15604@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0598D30@AVEXCH02.qlogic.org> <20031125012247.GB140407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:30981 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262108AbTKYISY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 03:18:24 -0500
Content-Disposition: inline
In-Reply-To: <20031125012247.GB140407@sgi.com>; from jeremy@sgi.com on Mon, Nov 24, 2003 at 05:22:47PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Mon, Nov 24, 2003 at 05:22:47PM -0800, Jeremy Higdon wrote:
> We don't use NVRAM settings on Irix.
> We do have a number of 2300-type boards which, for example, don't work
> in 2GB mode unless you bypass the NVRAM setting.  There are also problems
> with using 1KB frames instead of 2KB frames.
> 
> How about a config option that bypasses the NVRAM.  That way, if one
> of your customers wants to use it to set different values, they can
> use NVRAM.  If others don't want to use NVRAM, then they won't.

Wouldn't life be much easier if we just had a tiny opesource tool to
modify the nvram?, nothing fancy, just numerical setting of the values..

