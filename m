From: Doug Ledford <dledford@redhat.com>
Subject: Re: scsi_malloc fragmentation in 2.4.X
Date: Fri, 20 Dec 2002 15:39:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021220203902.GF4166@redhat.com>
References: <70300000.1040416318@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70300000.1040416318@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 20, 2002 at 01:31:58PM -0700, Justin T. Gibbs wrote:
> Are there any plans to correct the scsi_malloc fragmentation problems
> in 2.4.X?  It looks like this problem has been addressed in 2.5.X by using
> memory pools, but the current 2.4.X solution of just "backing off a bit"

Not in my plans anyway.  There's so much broken in 2.4 that fixing it 
means upgrading to 2.6 when available IMHO, so that's why I'm trying to 
get 2.6 fixed up as fast as possible and letting 2.4 be as it is.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
