From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 12:26:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210311225260.23076-100000@beppo>
References: <20021031200758.GB30047@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021031200758.GB30047@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

> 
> We currently only do report luns on SCSI-3 devices.  I didn't think this 
> was a supported command on SCSI-2, but I hadn't checked the spec 
> recently...hmmm...nope, not supported in SCSI-2, so using report luns on 
> SCSI-2 devices is just as much a hack as going above lun 7 on SCSI-2 
> devices without specific knowledge of transfer interconnect.

It's transitional in that a number of devices report as SCSI-2 but do
things like REPORT LUNs. It's changing very fast though.


