From: David Rientjes <rientjes@google.com>
Subject: RE: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Date: Wed, 25 May 2011 16:40:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1105251639290.29729@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com> <20110525080409.GA16582@infradead.org> <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
 <13EBEADFAA5B5041B7FC8A3311E7DD1C044D22F3@XMB-RCD-104.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:59594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab1EYXk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2011 19:40:57 -0400
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id p4PNek1T028079
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 16:40:46 -0700
Received: from pxi19 (pxi19.prod.google.com [10.243.27.19])
	by kpbe20.cbf.corp.google.com with ESMTP id p4PNejKO013137
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 16:40:45 -0700
Received: by pxi19 with SMTP id 19so122963pxi.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 16:40:45 -0700 (PDT)
In-Reply-To: <13EBEADFAA5B5041B7FC8A3311E7DD1C044D22F3@XMB-RCD-104.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
Cc: Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Abhijeet Joglekar (abjoglek) wrote:

> As Roland indicated, the correct fix would be to remove the 
> SLAB_CACHE_DMA flag from the call to kmem_cache, and the GFP_DMA from 
> the call to the mempool allocation routine.
> 
> I can create a patch (attributing the fix to David and Roland) and send 
> out for review. Or if David wants, he can modify the patch he submitted 
> to include this fix. David, please let me know how you want to proceed.
> 

It'd be great if you could create a patch, you would certainly be able to 
speak with more authority on the hardware requirements in the changelog 
than I would :)

Thanks Roland, Christoph, and Abhijeet!
