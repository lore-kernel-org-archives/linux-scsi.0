From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Add transport_handle_cdb_direct
	optimization
Date: Fri, 17 Jun 2011 16:41:59 +0200
Message-ID: <20110617144159.GA31052@lst.de>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org> <1307167290-24832-2-git-send-email-nab@linux-iscsi.org> <20110604140308.GB13359@lst.de> <4DFA55D6.8090101@redhat.com> <20110616192256.GA14124@lst.de> <4DFA83CA.60600@redhat.com> <20110617120139.GA28409@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37428 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1FQOmA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 10:42:00 -0400
Content-Disposition: inline
In-Reply-To: <20110617120139.GA28409@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 17, 2011 at 02:01:39PM +0200, Christoph Hellwig wrote:
> On Thu, Jun 16, 2011 at 03:29:30PM -0700, Andy Grover wrote:
> > I don't think we should be making it easy on the core, I think we should
> > be making it easy on the *fabrics*, if for no other reason that there
> > are >1 of them, but only one core. Less code duplicated.
> 
> The userspace offload really is just a call to the workqueue code.  I

s/userspace/user context/

