From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Wed, 15 Jun 2005 15:15:46 -0500
Message-ID: <1118866546.5045.76.camel@mulgrave>
References: <1118590709.4967.6.camel@mulgrave>
	 <20050613145000.GA12057@gmail.com> <1118674783.5079.9.camel@mulgrave>
	 <20050613183719.GA8653@gmail.com> <1118695847.5079.41.camel@mulgrave>
	 <20050613214208.GA7471@janus> <1118703593.5079.56.camel@mulgrave>
	 <20050614214226.GA15560@janus> <20050615120237.GB19645@janus>
	 <1118844888.5045.18.camel@mulgrave>  <20050615200957.GA23096@janus>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:57515 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261534AbVFOUQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 16:16:04 -0400
In-Reply-To: <20050615200957.GA23096@janus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Gr?goire Favre <gregoire.favre@gmail.com>, dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-06-15 at 22:09 +0200, Frank van Maarseveen wrote:
>         User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
>         Goal: 10.000MB/s transfers (10.000MHz, offset 15)
>         Curr: 10.000MB/s transfers (10.000MHz, offset 15)

This would be why ... you need to set you bios to 10MHz narrow (it's
currently set to 40MHz wide).

James


