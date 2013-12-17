From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Mon, 16 Dec 2013 19:03:26 -0800
Message-ID: <1387249406.20247.288.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1387231426.20247.260.camel@haakon3.risingtidesystems.com>
	 <52AFADB3.3060101@redhat.com>
	 <1387245542.20247.284.camel@haakon3.risingtidesystems.com>
	 <52AFB0FF.9000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52AFB0FF.9000101@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-12-16 at 18:03 -0800, Andy Grover wrote:
> On 12/16/2013 05:59 PM, Nicholas A. Bellinger wrote:
> 
> > I do appreciate the effort, but the extra pointer chasing here makes
> > rbtrees prohibitively expensive for fast past operations.
> 
> Hmm, were they actually implemented and tried at some point?
> 

This is based upon experiences with PCIe IOV addressing using rbtrees.

--nab
