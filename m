From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
Date: Fri, 27 May 2011 08:47:52 +0900
Message-ID: <20110527084752T.fujita.tomonori@lab.ntt.co.jp>
References: <1306445587.23461.22.camel@haakon2.linux-iscsi.org>
	<1306451068.4048.69.camel@mulgrave.site>
	<1306452490.23461.60.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306452490.23461.60.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de, agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz, jxm@risingtidesystems.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 26 May 2011 16:28:10 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> As we have discussed at length over the years, the split needs to be all
> userspace or all kernelspace, and when implementations start doing
> things in-between they quickly get painful to debug, maintain and
> extend.  I have no interest in trying to evolve this further when LIO

Sorry, I disagree. As I explained, once user space passes established nexuses
to kernel, kernel handles all. I don't think it's painful.


> from the default two cases provided in their series, but lets please,
> please avoid slipping yet another window here when we still have >= 15K
> LOC in three other HW target mode fabric drivers in flight for the next
> round

Why can't you push other fabric drivers before iSCSI one?
