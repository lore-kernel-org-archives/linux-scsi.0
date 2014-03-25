From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/39] virtio_scsi: use cmd_size
Date: Tue, 25 Mar 2014 08:31:04 -0700
Message-ID: <20140325153104.GA25748@infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
 <20140317133133.814453025@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140317133133.814453025@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Paolo,

do you have a virtio_scsi tree to picks this up in?  We now have all
the infrastructure for it in James' tree.

Btw, it would also be interesting to see if we could get rid of
virtscsi_cmd_cache/pool by reusing fields in EH, but I didn't feel
familar enough with the driver to look into that.
