From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
 crc32-intel offload
Date: Mon, 13 Sep 2010 15:35:01 -0500
Message-ID: <4C8E8AF5.5080205@cs.wisc.edu>
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>	 <4C8DED17.6080801@suse.de> <1284407432.8171.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284407432.8171.41.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On 09/13/2010 02:50 PM, Nicholas A. Bellinger wrote:
>> IE the in-kernel crc32c routines apparently weren't able to
>> calculate the checksum in an endianness-independent manner.
>> So a CRC calculated on a BE machine would fail to be validated by a
>> LE machine and vice versa.
>>
>> Has this been fixed / verified?
>>
>
>> From taking a look at crypto/crc32c.c it still appears AFAICT to not be
> big endian safe.  I was planning to test this patch on some powerpc/ppc
> hardware with v2.6.36-rc4 in the next days, but it looks like
> lio-core-2.6.git will need a seperate crypto/crc32c.c patch to function
> properly on big endian arches.
>

There was this bug that was fixed a couple years ago:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ef19454bd437b2ba14c9cda1de85debd9f383484
since then I think we have not had problems.
