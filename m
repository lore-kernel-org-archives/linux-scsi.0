From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] [PATCH 0/3] Convert ipr to use
 ata_port_operations->error_handler
Date: Mon, 13 Jun 2016 18:15:24 -0400
Message-ID: <20160613221524.GK31708@htj.duckdns.org>
References: <CAOS58YO65A8TpH22tEdM4SUcn8ncpY1f_YFMzomCN09OvhoRaQ@mail.gmail.com>
 <57470450.3070000@linux.vnet.ibm.com>
 <575B3215.5070602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:36524 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbcFMWP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2016 18:15:27 -0400
Content-Disposition: inline
In-Reply-To: <575B3215.5070602@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

On Fri, Jun 10, 2016 at 04:33:09PM -0500, Brian King wrote:
> On 05/26/2016 09:12 AM, Brian King wrote:
> > On 05/25/2016 02:32 PM, Tejun Heo wrote:
> >> Hello, Brian.
> >>
> >> So, of all the ata drivers, ipr seems to be the only driver which
> >> doesn't implement ata_port_opeations->error_handler and thus depends
> >> on the old error handling path. I'm wondering whether it'd be possible
> >> to convert ipr to implement ->error_handler and drop the old path.
> >> Would that be difficult?
> > 
> > Last time I looked at that there were a number of challenges in doing that,
> > but let me take another look and see if we can figure out a way to do that.
> 
> Here is an initial attempt to do this conversion. Probably plenty of bugs
> in it, and more testing is needed before this would be ready to apply.

Thanks a lot for working on this. :)

-- 
tejun
