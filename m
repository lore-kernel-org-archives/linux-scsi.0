From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 15:38:47 -0500
Message-ID: <1282595927.11194.78.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	 <1282077040.16098.47.camel@mulgrave.site> <4C6C1DC1.8090208@vlnb.net>
	 <1282164188.10878.22.camel@mulgrave.site> <4C702030.2070306@vlnb.net>
	 <1282423128.3015.35.camel@mulgrave.site>
	 <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
	 <1282582740.11194.17.camel@mulgrave.site>  <4C72CEC5.4080204@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C72CEC5.4080204@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Gennadiy Nerubayev <parakie@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-08-23 at 23:40 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley, on 08/23/2010 08:59 PM wrote:
> > My basic conclusion was that there's no incredible discriminator between
> > LIO and STGT (although there are reams written on which performs better
> > in which circumsances, is useful for clustering, supports ALUA, etc.
> > each with partisans for the features).
> 
> Here is a comprehensive features comparison I prepared some time ago: 
> http://scst.sourceforge.net/comparison.html. It's a bit outdated at the 
> moment, but I'm going to make it completely up do date in the next few days.

That's not really going to help ... I don't really want another 500 mail
thread of partisan yelling about which is better.  I'm happy to concede
that either could beat the other on a given set of well chosen tests ...
but knowing that is completely useless to me.  I can also guess, given
the antipathy, that neither of you would agree on a definitive set of
comparison tests.

So it comes down to a community test instead: which works better with
the community.  This is important to me because it's an indication of
what might ensue once code goes upstream and thus moves outside the
exclusive province of the project to become a community resource. STGT
is a community too and so far what you seem to have told me is:

      * STGT users should just migrate to scst_local
      * STGT doesn't have enough users to bother with
      * STGT has fundamental design flaws which makes its pass through
        architecture unusable and its ABI flawed.

I'm sure STGT appreciates the frank assessments, but it doesn't seem to
merit too many "plays well with others" points.

James
