From: Matthew Wilcox <willy@debian.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 12 Dec 2003 12:48:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031212124854.GH27116@parcelfarce.linux.theplanet.co.uk>
References: <200312112117.46216.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42414 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264549AbTLLMs6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 07:48:58 -0500
Content-Disposition: inline
In-Reply-To: <200312112117.46216.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI -DEVEL <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Thu, Dec 11, 2003 at 09:17:46PM +0530, N.C.Krishna Murthy wrote:
> Hi,
> 	One of your comments was
> "having multiple kmap() in the same process at the same time can deadlock(),
> you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do that.
> for the tx path use ->sendpage to avoid a data copy and kmapping altogether".
> 
> I did try using sendpage in iscsi_xmit_data. 
> Whenever the scatterlist->length was 4096 sendpage did succeed.
> When it was 8192 I did see a panic 

could you post the code for that?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
