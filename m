From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 23:41:24 +0400
Message-ID: <4C72CEE4.7020104@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>	 <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HWTlc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 15:41:32 -0400
In-Reply-To: <1282508953.3042.102.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org

James Bottomley, on 08/23/2010 12:29 AM wrote:
> So the phrase "up to GigE" was deliberately in the above to exclude the
> disputed infiniband results.  I'm not really interested in re-opening
> the arguments over how to interpret those results.  The fact that SCST
> and STGT were on par up to 1GbE is enough to refute the contention that
> STGT is "fundamentally slow".

Well, James, why not 100MbE? If you want a comparison of target 
implementations you need a fast hardware with minimal latency. 
Otherwise, the difference between the implementations can drown in the 
overhead of the accompanying processing. 1GbE is a nearly 10 years ago 
interface. Or are we going to stay ten years behind progress?

Thanks,
Vlad
