From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 25 Nov 2003 15:31:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125233103.GA146781@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0598D39@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:32429 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S263504AbTKYXb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 18:31:58 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598D39@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Tue, Nov 25, 2003 at 11:29:40AM -0800, Andrew Vasquez wrote:
> 
> > There are also problems with using 1KB frames instead of 2KB frames.
> > 
> > How about a config option that bypasses the NVRAM.  That way, if one
> > of your customers wants to use it to set different values, they can
> > use NVRAM.  If others don't want to use NVRAM, then they won't.
> > 
> 
> Perhaps our best route would be to provide a opensource tool to do
> NVRAM updates (as Christoph suggested in an ealier email).  I'll see
> what I can do to get that to happen.


Yes, that would be best.

jeremy
