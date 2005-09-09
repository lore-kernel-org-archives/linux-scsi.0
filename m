From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.6.13 1/20] aic94xx: Makefile
Date: Fri, 9 Sep 2005 16:11:41 -0400
Message-ID: <20050909201141.GA14862@havoc.gtf.org>
References: <4321E335.5010805@adaptec.com> <20050909193541.GE24673@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030440AbVIIULt@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050909193541.GE24673@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 09, 2005 at 03:35:41PM -0400, Benjamin LaHaise wrote:
> A single file per patch is not really a patch split up.  Patches should 
> stand on their own, leaving the tree in a compilable functioning state 
> during each step.

Agreed, though for new drivers, this appears to be one way to get new
code past mailing list size filters, making it easier for the linux-scsi
audience to review the code.  The alternative is posting a link, which
cuts down on mailing list spew, but also I bet cuts down on review.

	Jeff
