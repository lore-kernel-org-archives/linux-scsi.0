From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [linux-iscsi-devel] [question] deferred sense
Date: Wed, 5 Jan 2005 22:58:06 +0000
Message-ID: <20050105225806.GF27371@parcelfarce.linux.theplanet.co.uk>
References: <60807403EABEB443939A5A7AA8A7458B9B94AF@otce2k01.adaptec.com> <1104961917.3883.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38630 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262641AbVAEW6I
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 17:58:08 -0500
Content-Disposition: inline
In-Reply-To: <1104961917.3883.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jan 05, 2005 at 04:51:57PM -0500, James Bottomley wrote:
> I suggest you publish the API to linux-scsi and linux-ide since we'd be
> the primary implementers.  The fs changes should go to the relevant fs
> lists (probably cc linux-kernel) and we'll be glad to look them over.

linux-fsdevel (@vger) would probably be the right place to get feedback
from filesystem authors.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
