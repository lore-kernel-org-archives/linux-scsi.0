From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch 4/7] megaraid_sas: adds reboot handler
Date: Thu, 21 Sep 2006 12:44:26 +0100
Message-ID: <20060921114426.GA30858@infradead.org>
References: <1158804171.4171.51.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750952AbWIULob@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1158804171.4171.51.camel@dumbo>
Sender: linux-kernel-owner@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org, Neela.Kolli@lsil.com, Bo.Yang@lsil.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 20, 2006 at 07:02:51PM -0700, Sumant Patro wrote:
> This patch adds handler to get reboot notification and fires flush command from 
> the reboot notification handler. 

NACK, this should be handled by the PCI driver ->shutdown method instead.
