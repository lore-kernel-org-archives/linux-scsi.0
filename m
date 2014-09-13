From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix regression that accidentally disabled
 block-based tcq
Date: Sat, 13 Sep 2014 10:50:47 -0700
Message-ID: <20140913175047.GA28882@infradead.org>
References: <540EC52C.3000804@redhat.com>
 <20140909152730.GA17882@infradead.org>
 <540FFBF4.9090001@redhat.com>
 <20140910154535.GA5102@infradead.org>
 <541172E9.8070309@redhat.com>
 <20140911161331.GA24488@infradead.org>
 <54134E50.6040805@redhat.com>
 <20140912230032.GA21143@infradead.org>
 <54141C59.7040707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54141C59.7040707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 13, 2014 at 12:28:41PM +0200, Hans de Goede wrote:
> Yes this one does the trick and fixes things. Note the git tree I used for
> testing also had your previous fix to split up the blk_tcq union in 2
> separate struct members. Let me know if you want me to re-test without that
> fix.

I'm pretty sure that isn't needed, so double testing it indeed doesn't
would be helpful.  I'd like to add your Tested-by: tag after that, too.
