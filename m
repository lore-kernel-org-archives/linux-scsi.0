From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Fri, 20 Dec 2002 17:59:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <190380000.1040432350@aslan.btc.adaptec.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <176730000.1040430221@aslan.btc.adaptec.com>
 <20021221002940.GM25000@holomorphy.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021221002940.GM25000@holomorphy.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> At some point in the past, Janet Morgan had her attribution removed:
>>> I have an Adaptec AIC-7897 Ultra2 SCSI adapter on a system with 8G
>>> of physical memory.  The adapter is using bounce buffers when DMA'ing
>>> to memory >4G because of a bug in the aic7xxx driver. 
> 
> On Fri, Dec 20, 2002 at 05:23:42PM -0700, Justin T. Gibbs wrote:
>> This has been fixed in both the aic7xxx and aic79xx drivers for some
>> time.  The problem is that these later revisions have not been integrated
>> into the mainline trees.
> 
> Could you split up the new revisions into a series of reviewable
> patches with clearly-defined individual scope and descriptive changelog
> entries and post them (in your mail message, not as URL's) please? I
> actually use this driver at home, so I'd like to be able to understand
> what's going on with it. I suspect various others are of like mind.
> 
> 
> Thanks,
> Bill

You can review all of that information by browsing the BK depot at:

http://linux-scsi.bkbits.net:8080/scsi-aic7xxx-2.5

Since the drivers in 2.4 and 2.5 are almost identical, the changelogs
there apply for 2.4.X too.

