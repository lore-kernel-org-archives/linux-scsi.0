From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 09:34:25 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DAB5@otce2k301.adaptec.com>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024173019I.tomof@acm.org> <471F2D12.50006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758734AbXJXNe5@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <471F2D12.50006@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, AACRAID <aacraid@adaptec.com>, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik [mailto:jeff@garzik.org] writes:
> is this needed, given that the default is already 65536?

Apparently so, as we had to add it in the past, mainly because the
feature to limit was not part of the SCSI layer when the original limit
code was added. At that time it replaced a complicated sg breakup
algorithm.

Does your statement guarantee that the default will not change to a
large value? If not, then we need to enforce it in perpetuity...

Sincerely -- Mark Salyzyn
