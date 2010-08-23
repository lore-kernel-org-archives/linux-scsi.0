From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 09:47:23 -0400
Message-ID: <4C727BEB.9020100@scalableinformatics.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	<1282144271.3035.31.camel@mulgrave.site>	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	<1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	<41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	<8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>	<4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282508953.3042.102.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:

> So the phrase "up to GigE" was deliberately in the above to exclude the
> disputed infiniband results.  I'm not really interested in re-opening
> the arguments over how to interpret those results.  The fact that SCST
> and STGT were on par up to 1GbE is enough to refute the contention that
> STGT is "fundamentally slow".

We haven't tested this in at least 6 months, but we did test iSCSI over 
10GbE using SCST and STGT.  This was one of the reasons we wound up 
going with SCST.  For the past several years, our performance on SCST 
was much higher than on STGT.

If it helps, we can redo these tests with a modern kernel (2.6.35.x) and 
same backend/frontend.  We've been switching most of our IO performance 
testing to Jens Axboe's excellent fio tool.  I'd be happy to share our 
testing decks with anyone (and collaborate on generating a good useful 
set for general use)

This said, I have to add in my support to SCST and its developers. 
Vlad, Bart, and the rest of the community have been very helpful to us. 
  We have been a consumer rather than a developer to date, so we have 
less of a dog in this fight than others.  We have nothing against LIO or 
STGT.  We will try them and see if they meet our needs.  SRP is a hard 
requirement, and it exists and works great in SCST.  So for us, a 
solution which gives us the best of all worlds would be one where we 
don't have to give up what works well for us, and gets us new 
capabilities/features.  This is more of a wish-list ... we have to keep 
using what works well for us.

Our interest in STGT is that we would like a working iSER.  Vlad has 
suggested a method that we will explore a little later on (next
month).  The LIO folks do look like they have some interesting 
capabilities beyond this, so we will look.  But without SRP, and a fast 
iSCSI, their really isn't much choice for us in the near term.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
