From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Generic SCSI Target Mid-level For Linux (followup)
Date: Sat, 12 Jul 2008 09:52:47 +0200
Message-ID: <e2e108260807120052j5264ba21u118dda546128dd35@mail.gmail.com>
References: <4873BCA5.10103@vlnb.net>
	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
	 <48749EB2.1070902@vlnb.net>
	 <1215632043.9339.89.camel@haakon2.linux-iscsi.org>
	 <48765433.70604@vlnb.net>
	 <1215725167.31245.104.camel@haakon2.linux-iscsi.org>
	 <4877A948.6090507@vlnb.net>
	 <1215833281.13668.94.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:17096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYGLHwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jul 2008 03:52:51 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1684397fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2008 00:52:48 -0700 (PDT)
In-Reply-To: <1215833281.13668.94.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Andrew Morton <akpm@osdl.org>, Rafiu Fakunle <rafiu@openfiler.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>, Mike Mazarick <mazarick@bellsouth.net>, Leonid Grossman <leonid.grossman@neterion.com>, linux-kernel@vger.kernel.org, Pete Wyckoff <pw@osc.edu>, "Ross S. W. Walker" <rwalker@medallion.com>, scst-devel <scst-devel@lists.sourceforge.net>, Ted Ts'o <tytso@thunk.org>, "H. Peter Anvin" <hpa@zytor.com>, Jerome Martin <tramjoe.merin@gmail.com>, Christoph Hellwig <hch@lst.de>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Sat, Jul 12, 2008 at 5:28 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Using MC/S with a modern iSCSI implementation to take advantage of lots
> of cores and hardware threads is something that allows one to multiplex
> across multiple vendor's NIC ports, with the least possible overhead, in
> the OS INDEPENDENT manner.

Why do you emphasize MC/S so much ? Any datacenter operator that has
the choice between MC/S and using a faster network technology will
choose the last IMHO. It's much more convenient to use e.g. 10 GbE
instead of multiple 1 GbE connections.

Bart.
