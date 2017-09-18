From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] megaraid: kmemleak: Track page allocation for fusion
Date: Mon, 18 Sep 2017 09:21:35 -0700
Message-ID: <20170918162135.GA20366@infradead.org>
References: <20170915052152.5032-1-shuwang@redhat.com>
 <20170915180007.GA24045@infradead.org>
 <f582abfe99a5a00f876d5bbefdb306fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f582abfe99a5a00f876d5bbefdb306fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: Christoph Hellwig <hch@infradead.org>, shuwang@redhat.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, yizhan@redhat.com, catalin.marinas@arm.com
List-Id: linux-scsi@vger.kernel.org

Oh, I missed log_to_span.  Well, in that case log_to_span is
_the_ candidate for moving into a separate allocation.

And in fact you're probably better off by using a sensible data
structure for it, e.g. a radix tree.
