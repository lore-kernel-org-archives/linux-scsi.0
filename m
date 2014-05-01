From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCHv2 RESEND 0/9] target: Save memory on unused se_dev_entrys
 and se_luns
Date: Thu, 01 May 2014 14:51:42 -0700
Message-ID: <5362C1EE.40106@redhat.com>
References: <1395704598-31073-1-git-send-email-agrover@redhat.com>	 <5358406B.5040906@redhat.com> <20140425053458.GA30932@lst.de>	 <53628A29.1080207@redhat.com> <1398979268.24007.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1398979268.24007.26.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/01/2014 02:21 PM, Nicholas A. Bellinger wrote:

> So now that target code (plus Sagi's patches) is finally working
> correctly with active I/O shutdown with iser + friends, I'm not exactly
> crazy about introducing a bunch of changes that potentially break long
> standing assumptions about how se_lun + se_dev_entry pointers are
> accessed.

This saves a huge amount of wasted memory per nodeacl and per tpg. It's 
a net reduction of 120 lines of code.

If you wanted to push the iser work to Linus by itself, maybe this goes 
into your tree immediately after that? That would give it plenty of time 
in your tree before it went upstream.

> That said, I'd much rather see proper percpu refcounting for
> se_dev_entry introduced ahead of these types of memory space related
> optimizations.

These patches are not refcount-related, so they should be orthogonal to 
any refcount improvements.

I think the set from March 24 should still apply, but I'm happy to 
re-send or post a repo if that would be helpful to you.

Regards -- Andy
