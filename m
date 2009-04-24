From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Fri, 24 Apr 2009 13:00:49 +0200
Message-ID: <49F19BE1.6030104@s5r6.in-berlin.de>
References: <20090422090929.GA14928@havoc.gtf.org> <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Grant Grundler wrote:
> Data Center
> environments (not just Google's) like to track disks in many different
> ways, including the SCSI identifiers since this one "key" for physical
> location. Breaking the current mappings is going to cause some people
> a world of pain

If by SCSI identifiers you mean the Linux SCSI core's h:c:i:l, then
remember that these are scsi-core internal artifacts without any meaning
to lower and upper layers whatsoever, including userspace.  (Exception:
 The c:i:l part has some significance with SCSI Parallel Interface
attached hardware.)

> since they will need to manually build (and integrate)
> old->new maps of the SCSI identifiers.

Stock udev already provides mapping according to actually useful
identifiers (if the respective transport provides them: persistent and
unique identifiers of targets and logical units).
-- 
Stefan Richter
-=====-==--= -=-- ==---
http://arcgraph.de/sr/
