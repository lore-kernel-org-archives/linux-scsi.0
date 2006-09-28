From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: use_clustering again (was Re: SCSI tape block size)
Date: Thu, 28 Sep 2006 15:50:45 -0400
Message-ID: <451C2795.8040509@cs.wisc.edu>
References: <200609241605.32327.johna@onevista.com> <Pine.LNX.4.60.0609272246320.7350@poirot.grange> <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local> <Pine.LNX.4.60.0609282211560.3268@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:964 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750847AbWI1Uwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 16:52:32 -0400
In-Reply-To: <Pine.LNX.4.60.0609282211560.3268@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Thu, 28 Sep 2006, Kai Makisara wrote:
> 
>> The limits come from the block subsystem that all scsi devices use 
>> nowadays. It is a rather long story but can be found from linux-scsi 
>> archives, e.g.,
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=114147170831847&w=2
> 
> Yes, already found the 2 later threads - one on lkml and one on scsi. I 
> did look at them briefly back then, but, probably, too briefly.
> 
> One of the settings - enable_clustering 

If you are just trying to get to 1MB, then instead of enabling
clustering we could also increase the defaul SCSI_MAX_PHYS_SEGMENTS. It
is 128 now, but there is a compile option to set it it up to 256.

Well, actually I think that gets a little short because SG_ALL is only
255. Why is SG_ALL 255, but you can set SCSI_MAX_PHYS_SEGMENTS to 256?
