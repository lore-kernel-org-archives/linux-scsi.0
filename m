From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 15:31:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <837658112.1041114694@aslan.scsiguy.com>
References: <200212282224.gBSMO5h03843@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200212282224.gBSMO5h03843@localhost.localdomain>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> gibbs@scsiguy.com said:
>> Hmm.  The only previous bug report I had in this area was related to a
>> missing cast.  That was fixed, but I guess it wasn't enough to solve
>> the problem. 
> 
> It looks like possibly a config option that doesn't exist

Yes.  It seems to only exist in 2.4.X.  I'll have to use a different
method for toggling the highmem_io option in the host structure.

--
Justin

