From: Doug Ledford <dledford@redhat.com>
Subject: Re: Q: calling SCpnt->scsi_done() on cancelled commands?
Date: Mon, 24 Jun 2002 11:37:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020624113706.C18959@redhat.com>
References: <3D13E91C.4E7BD549@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D13E91C.4E7BD549@splentec.com>; from luben@splentec.com on Fri, Jun 21, 2002 at 11:03:56PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 21, 2002 at 11:03:56PM -0400, Luben Tuikov wrote:
> 
> What is the future of calling scsi_done() on
> cancelled by the mid-layer commands?

If I have anything to say about it, mandatory.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
