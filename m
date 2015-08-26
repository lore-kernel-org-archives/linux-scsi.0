From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Wed, 26 Aug 2015 16:58:34 -0700
Message-ID: <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	 <20150826235434.GA8843@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150826235434.GA8843@mail.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-08-26 at 16:54 -0700, Calvin Owens wrote:
> On Wednesday 08/26 at 04:09 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi James & Co,
> > 
> > This series is a mpt3sas forward port of Calvin Owens' in-flight
> > reference counting bugfixes for mpt2sas LLD code here:
> > 
> > [PATCH v4 0/2] Fixes for memory corruption in mpt2sas
> > http://marc.info/?l=linux-scsi&m=143951695904115&w=2
> 
> Nicholas,
> 
> I'm glad to hear these fixes were helpful! I was planning on porting to
> mpt3sas in the near future, thanks for saving me the trouble :)
> 

Would you mind giving this series the once over, and add your
Reviewed-by as well..?

Sreekanth + Avago folks, can you please do the same for Calvin's mpt2sas
series and this series..?

This has been a long-standing issue with mpt*sas LLD code and really
needs to be addressed for upstream.

Thank you,

--nab
