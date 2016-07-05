From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] libata-scsi: improve TRIM translation
Date: Tue, 5 Jul 2016 18:43:20 -0400
Message-ID: <20160705224320.GE25394@htj.duckdns.org>
References: <577b57b0.5b4c620a.37648.6c8d@mx.google.com>
 <6f5400ce-58c8-d52c-9ce5-a1450b52599e@cogentembedded.com>
 <CAGnHSEkoJPzi0qQbu2SjqYehFW9o1g8d-mm=jYuQk=YgBKa8Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEkoJPzi0qQbu2SjqYehFW9o1g8d-mm=jYuQk=YgBKa8Yw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2016 at 03:10:51AM +0800, Tom Yan wrote:
> Well it is exactly what the patch does. We no longer do the "divide it
> by 8" thing each time we want to know the now defined TRIM_RANGE_NUM.
> 
> ata_set_lba_range_entries() has only been used by
> ata_scsi_write_same_xlat()
> (http://lxr.free-electrons.com/ident?i=ata_set_lba_range_entries,
> although the comment of it seems to tell otherwise). That's why I
> (could) changed the function itself and the param ("512")
> ata_scsi_write_same_xlat() passes to it.

Heh, I find the patch difficult to follow too and it shouldn't be.
Can you please split them up and explain what's going on in the
description?

Thanks.

-- 
tejun
