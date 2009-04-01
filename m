From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Iscsitarget-devel] [Scst-devel] ISCSI-SCST performance (withalso
	IET and STGT data)
Date: Wed, 1 Apr 2009 08:29:19 +0200
Message-ID: <e2e108260903312329u118a54bfn3107fdca4b3e2b1d@mail.gmail.com>
References: <49D10256.8030307@vlnb.net>
	 <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
	 <49D11096.3070804@vlnb.net>
	 <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
	 <49D254E4.8050806@vlnb.net>
	 <E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46643 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZDAG3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 02:29:22 -0400
In-Reply-To: <E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ross S. W. Walker" <RWalker@medallion.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, iscsitarget-devel@lists.sourceforge.net, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stgt@vger.kernel.org

On Tue, Mar 31, 2009 at 8:43 PM, Ross S. W. Walker
<RWalker@medallion.com> wrote:
> IET just needs to fix how it does it workload with CFQ which
> somehow SCST has overcome. Of course SCST tweaks the Linux kernel to
> gain some extra speed.

I'm not familiar with the implementation details of CFQ, but I know
that one of the changes between SCST 1.0.0 and SCST 1.0.1 is that the
default number of kernel threads of the scst_vdisk kernel module has
been increased to 5. Could this explain the performance difference
between SCST and IET for FILEIO and BLOCKIO ?

Bart.
