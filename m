From: brace <brace@pmcs.com>
Subject: RE: [PATCH 40/43] hpsa: cleanup initialization code.
Date: Tue, 24 Feb 2015 21:29:17 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB38D5D22B@BBYEXM01.pmc-sierra.internal>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221222105.21954.13148.stgit@brunhilda>
 <20150223202641.GG11037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:38212 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbbBXV3U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2015 16:29:20 -0500
In-Reply-To: <20150223202641.GG11037@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, brace <brace@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, February 23, 2015 2:27 PM
> To: Don Brace
> Cc: Scott Teel; Kevin Barnett; james.bottomley@parallels.com;
> hch@infradead.org; Justin Lindley; brace; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 40/43] hpsa: cleanup initialization code.
> 
> This is a backwards change.  Please keep the goto unwinding (maybe with
> some better label names) instead of introducing the if allocated free pattern.

Done.
