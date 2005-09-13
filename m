From: Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 14 Sep 2005 01:00:10 +1000
Message-ID: <20050913150009.GG26162@krispykreme>
References: <20050906212801.GB14057@cs.umn.edu> <20050907025932.GU6945@krispykreme> <431EFFE7.6070709@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932677AbVIMPcg@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <431EFFE7.6070709@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santiago Leon <santil@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Linda Xie <lxiep@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Hi,

> We use MAX_SECTORS (which is actually 127.5kB) because that's the 
> max_sectors of the loopback device (we have a lot of users that like the 
> flexibility of using loopback with the ibmvscsis driver)... It can be 
> bumped up without any problems because there is code that splits 
> requests if they are larger than the target's max_sectors...
> 
> What would you recommend? 256kB?

~256kB sounds reasonable to me and I notice that other VIO server is
setting it to 256kB :) 

Anton
