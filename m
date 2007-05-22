From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [patch 10/28] Fix |/|| confusion in fusion driver
Date: Tue, 22 May 2007 13:49:20 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70757DDE@NAMAIL4.ad.lsil.com>
References: <20070522005947.GC12157@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64450 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407AbXEVTub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 15:50:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070522005947.GC12157@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dmueller@suse.de

On Monday, May 21, 2007 7:00 PM,  Dave Jones wrote:
> 
> Andrew, the last time this was posted, Eric picked up on some other
> flaws in the same area. James asked him to followup with a patch, but
> unless I'm mistaken, that never arrived.
> This diff should replace the one in your tree until Eric has an
> equivalent or better.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 

ACK

Thanks Dave, this patch will work.  
