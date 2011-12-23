From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes +
 tcm_qla2xxx fabric module
Date: Fri, 23 Dec 2011 13:59:34 -0800
Message-ID: <1324677574.16979.109.camel@haakon2.linux-iscsi.org>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
	 <20111221171135.GA27369@lst.de>  <20111222222520.GP22063@plapa.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111222222520.GP22063@plapa.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <JBottomley@Parallels.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-22 at 14:25 -0800, Andrew Vasquez wrote:
> On Wed, 21 Dec 2011, Christoph Hellwig wrote:
> 
> > I think the most important item is to sort out the mess around the old
> > generation qla23xx support.  The way the code currently sprinkles ifs
> > around that is a complete mess.  Given that the qla23xx support has as
> > far as I know zero test coverage, and has been EOLed by qlogic I see
> > no reason to keep it around.
> > 
> > Anyone disagreeing with that?
> > 
> 
> Christoph,
> 
> >From an engineering and support perspective it doesn't make sense to
> keep the (unsupported and untested) pre-ISP24xx codes around.  Going
> forward, once internal resources can be allocated, QLogic would like
> to see support for all ISP24xx and above hardware.
> 
> Regards,
> Andrew Vasquez
> 

Hi Andrew,

Thanks for the official clarification here from Qlogic wrt to pre 24xx
hardware support in qla_target.c.  We will go ahead and begin dropping
the legacy support and plan to have all the old code removed for an
RFC-v5 series to be posted after the holidays.

Thank you,

--nab
