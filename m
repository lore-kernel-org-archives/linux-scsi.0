From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/3] - mpt fusion - panic in mptsas_slave_configure
Date: Fri, 14 Apr 2006 09:32:08 -0500
Message-ID: <1145025128.3520.10.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70080B50@NAMAIL4.ad.lsil.com>
	 <1144967295.3474.68.camel@mulgrave.il.steeleye.com>
	 <20060414010253.GA23580@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33737 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964823AbWDNOc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 10:32:27 -0400
In-Reply-To: <20060414010253.GA23580@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org

On Fri, 2006-04-14 at 02:02 +0100, Christoph Hellwig wrote:
> mptsas_slave_configure isn't anything sas transport class specificy, it's
> the ->slave_configure method in the host template for all fusion SAS
> controllers.  Independent of possibly needing a ->deny_binding this is the
> right thing to do here.

No, it's just me.  I keep forgetting that the sas transport class has no
device properties, so no device match routine;  that's the only place
you'd need a deny binding.  I'll put the patch in.

Thanks,

James


