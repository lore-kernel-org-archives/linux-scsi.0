From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] Fix error handler offline behaviour
Date: Wed, 17 Mar 2004 16:32:30 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317163230.GO25059@parcelfarce.linux.theplanet.co.uk>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6BB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:55187 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261809AbUCQQcd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 11:32:33 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6BB@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 17, 2004 at 11:29:04AM -0500, Salyzyn, Mark wrote:
> There was a scsi_device_online(Sdev) handler used in the patch, why not
> a scsi_device_set_online(Sdev) and a scsi_device_set_offline(Sdev)?

Because then we'd also need a scsi_device_is_online_p(Sdev) ... much
easier just to have a scsi_device_online(Sdev) that can be tested and
assigned to, as appropriate.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
