From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: BUG 2.6.24-rc4-mm1 -- Boot still hangs w/ async scsi scan
Date: Wed, 05 Dec 2007 16:44:45 -0500
Message-ID: <1196891086.5346.15.camel@localhost>
References: <1196872599.5346.8.camel@localhost>
	 <20071205132043.a80853d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35308 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXLEVx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 16:53:29 -0500
In-Reply-To: <20071205132043.a80853d9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Eric.Moore@lsi.com, Eric Whitney <eric.whitney@hp.com>

On Wed, 2007-12-05 at 13:20 -0800, Andrew Morton wrote:
> On Wed, 05 Dec 2007 11:36:39 -0500
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > As reported here:
> > 
> > 	http://marc.info/?l=linux-scsi&m=119645761124683&w=4
> > 
> > against 24-rc3-mm2, I'm still seeing the hang on my HP ia64 NUMA
> > platform under 24-rc4-mm1 with async scsi scan enabled.  I'm still
> > seeing the message  "mptspi: ioc#: mpt_config failed" when it hangs. 
> > 
> > I can boot by disabling async scan.  However, I've also noticed some
> > disks attached via one of the "mpt" adapters ["scsi8" in console long in
> > message linked above] going "off-line" during stress tests.  This was
> > under 24-rc3-mm2.  Haven't got that far yet with 24-rc4-mm1.
> > 
> 
> Is ther any way of tricking you into
> http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt?
> 
> Obvious culprits to start with would be git-scsi-misc and maybe
> scsi-early-detection-of-medium-not-present-updated.patch.  But there are
> only 20-odd scsi patches in there.

I'll try to get to it tomorrow am.  

Lee
> 

