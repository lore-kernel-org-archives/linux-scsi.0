From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
Date: Mon, 7 Jun 2010 17:56:27 +0900
Message-ID: <20100607175535Q.fujita.tomonori@lab.ntt.co.jp>
References: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
	<20100607154432Y.fujita.tomonori@lab.ntt.co.jp>
	<1275899236.26888.40.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, stgt@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 07 Jun 2010 01:27:16 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Ok, I just fixed some minor breakage and applied patch 3 on top of
> tgt.git/pass in my local tree and everything appears to work with
> '-E bsg -Y pt'.
> 
> Please let me know if you have any other comments on the BSG bits or if
> you would like me to send along a updated patch 3 seperately.

Please send patches except for bsg first.

About bsg support, we need both sg and bsg? Just bsg is not enough?
