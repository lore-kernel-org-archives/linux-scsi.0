From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Wed, 04 Jun 2008 18:56:35 +0200
Message-ID: <873antuojg.fsf@basil.nowhere.org>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760712AbYFDRZ0@vger.kernel.org>
In-Reply-To: <20080604235053K.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Wed, 4 Jun 2008 23:47:01 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
>
> I'm just interested in other people's opinions on IOMMU
> implementations, performances, possible future changes for performance
> improvement, etc.

I think using the bitmap is an excellent idea and your numbers look good. 
Do you have numbers on the memory consumption too?
Trading some memory for performance is ok for something as performance critical 
as the IOMMU. 

-Andi
