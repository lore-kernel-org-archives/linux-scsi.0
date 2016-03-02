From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] scsi_transport_fc: implement 'disable_target_scan'
	module parameter
Date: Wed, 2 Mar 2016 10:18:42 +0100
Message-ID: <20160302091842.GD1308@lst.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de> <1456127462-2817-2-git-send-email-hare@suse.de> <20160301131252.GA7786@lst.de> <56D6814B.9020302@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45056 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbcCBJSo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 04:18:44 -0500
Content-Disposition: inline
In-Reply-To: <56D6814B.9020302@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org

On Wed, Mar 02, 2016 at 01:59:39PM +0800, Hannes Reinecke wrote:
> Main reasons being that
> a) it's most commonly on FC where you end up having thousands of LUNs;
> SAS domains are of finite size and you'd need to string quite a few SAS
> expanders together to achieve a similar setup. And iSCSI is ... well.
> b) FC already has the required infrastructure in place where you easily
> can suppress a target scan, making the patch really trivial.
> 
> So rather than trying to come up with a generic solution and an overly
> complicated patch I opted for the simpler version :-)

Having a global disable just for all FC is still odd.  Either you
do it for all devices and always initiate a manual scan, or you
need to do it on a per-host basis somehow.
