From: Santiago Leon <santil@us.ibm.com>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 07 Sep 2005 09:57:43 -0500
Message-ID: <431EFFE7.6070709@us.ibm.com>
References: <20050906212801.GB14057@cs.umn.edu> <20050907025932.GU6945@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932156AbVIGO5y@vger.kernel.org>
In-Reply-To: <20050907025932.GU6945@krispykreme>
Sender: linux-kernel-owner@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxiep@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Anton,

> +	adapter->max_sectors = MAX_SECTORS;
> 
> Does this mean we are limited to 128kB transfers? Would it be OK to
> bump the default?

We use MAX_SECTORS (which is actually 127.5kB) because that's the 
max_sectors of the loopback device (we have a lot of users that like the 
flexibility of using loopback with the ibmvscsis driver)... It can be 
bumped up without any problems because there is code that splits 
requests if they are larger than the target's max_sectors...

What would you recommend? 256kB?

-- 
Santiago A. Leon
Power Linux Development
IBM Linux Technology Center
