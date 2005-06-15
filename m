From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Wed, 15 Jun 2005 09:14:48 -0500
Message-ID: <1118844888.5045.18.camel@mulgrave>
References: <1118081857.5045.49.camel@mulgrave>
	 <20050607085710.GB9230@gmail.com> <1118590709.4967.6.camel@mulgrave>
	 <20050613145000.GA12057@gmail.com> <1118674783.5079.9.camel@mulgrave>
	 <20050613183719.GA8653@gmail.com> <1118695847.5079.41.camel@mulgrave>
	 <20050613214208.GA7471@janus> <1118703593.5079.56.camel@mulgrave>
	 <20050614214226.GA15560@janus>  <20050615120237.GB19645@janus>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63910 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261445AbVFOOPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 10:15:11 -0400
In-Reply-To: <20050615120237.GB19645@janus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Gr?goire Favre <gregoire.favre@gmail.com>, dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-06-15 at 14:02 +0200, Frank van Maarseveen wrote:
> The -rc6 aic7 driver needs just over 7 minutes to recover from this tape
> unit. In -rc3 this was 80 seconds. -rc2 had no problem.
> 
> I don't really need this old tape unit and I don't [re-]boot that often
> so it is not a problem for me. Anyway, if something needs to be tested
> then mail me a patch (for stock rc6) and I'll try it.

Well, the patches to try are the scsi-misc ones:

http://parisc-linux.org/~jejb/scsi_diffs/scsi-misc-2.6.diff

James


