From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] hpsa: fix uninitialized trans_support in
 hpsa_put_ctlr_into_performant_mode()
Date: Thu, 10 Apr 2014 15:37:39 -0700
Message-ID: <1397169459.2608.61.camel@buesod1.americas.hpqcorp.net>
References: <20140410221704.GA22465@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20140410221704.GA22465@beardog.cce.hp.com>
Sender: linux-pci-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bjorn Helgaas <bhelgaas@google.com>, Baoquan He <bhe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>, Jiang Liu <jiang.liu@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-04-10 at 17:17 -0500, scameron@beardog.cce.hp.com wrote:
> Without this, you'll see a null pointer dereference in
> hpsa_enter_performant_mode().

So I'm not surprised that this patch doesn't solve the problem I am
seeing with DMAR and the hpsa driver hard lockup.

In any case it should address Baoquan's original report, so it confirms
that it is in fact two different sets of issues.
