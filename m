From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/4] fusion: remove iopriority handling
Date: Thu, 13 Oct 2016 22:34:49 -0700
Message-ID: <20161014053449.GA16510@infradead.org>
References: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
 <1476399631-5799-3-git-send-email-adam.manzanares@hgst.com>
 <CAJVOszDaOiDN1nMW7X6pgEkjSkE9+hNE0doUc-hweJc-qtAu3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJVOszDaOiDN1nMW7X6pgEkjSkE9+hNE0doUc-hweJc-qtAu3w@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Adam Manzanares <adam.manzanares@hgst.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Sathya Prakash <sathya.prakash@broadcom.com>, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> Style wise you can further remove the extra parens around
>   SCpnt->device->tagged_supported
> As well as the now redundant braces.

I did send a patch looking just like that earlier :)
