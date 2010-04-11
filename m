From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] scsi: Add lockdep annotations to SAS sysfs
 attributes.
Date: Sun, 11 Apr 2010 13:11:32 -0700 (PDT)
Message-ID: <20100411.131132.193718466.davem@davemloft.net>
References: <20100410.214017.165974351.davem@davemloft.net>
	<1270989312.2806.644.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1270989312.2806.644.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>
Date: Sun, 11 Apr 2010 07:35:12 -0500

> On Sat, 2010-04-10 at 21:40 -0700, David Miller wrote:
>> They are allocated dynamically, and thus need sysfs_attr_init()
>> treatment.
> 
> This should all be taken care of by
> 
> commit ebd09ec93c90c8ec571d7e166832fb1fc705bf5e
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Sat Mar 20 12:44:12 2010 -0500

Thanks, that should take care of it, my sparc-2.6 tree hadn't
sync'd with Linus's tree in a while. :-)
