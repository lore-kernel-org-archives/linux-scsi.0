From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Fri, 20 Dec 2002 17:23:42 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <176730000.1040430221@aslan.btc.adaptec.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
Content-Disposition: inline
To: Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> I have an Adaptec AIC-7897 Ultra2 SCSI adapter on a system with 8G
> of physical memory.  The adapter is using bounce buffers when DMA'ing
> to memory >4G because of a bug in the aic7xxx driver. 

This has been fixed in both the aic7xxx and aic79xx drivers for some
time.  The problem is that these later revisions have not been integrated
into the mainline trees.

--
Justin
