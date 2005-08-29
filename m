From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] SCSI EH document
Date: Mon, 29 Aug 2005 20:49:54 +0100
Message-ID: <20050829194954.GH26314@parcelfarce.linux.theplanet.co.uk>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com> <431358FB.6050005@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37520 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S1751471AbVH2Tqu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 15:46:50 -0400
Content-Disposition: inline
In-Reply-To: <431358FB.6050005@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>, James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

On Mon, Aug 29, 2005 at 02:50:35PM -0400, Jeff Garzik wrote:
> Every node is a list_head.  You want all pointers for all nodes pointing 
> to something useful, even if they are not actively present on a list, so 
> that they may be easily and corrected added to a list at a later time. 
> Read list_del_init() for example.

I disagree.  If you know what you're doing, it's perfectly fine to
simply list_del and not init the nodes.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
