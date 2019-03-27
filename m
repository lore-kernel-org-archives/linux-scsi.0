From: Hussam Al-Tayeb <ht990332@gmx.com>
Subject: Re: [PATCH] scsi: sd: Quiesce warning if device does not report
 optimal I/O size
Date: Wed, 27 Mar 2019 20:05:34 +0200
Message-ID: <b2dc0705a922019283ae7a2a514400163418febc.camel@gmx.com>
References: <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org>
         <20190327161152.23401-1-martin.petersen@oracle.com>
         <1553705173.118779.98.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1553705173.118779.98.camel@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-03-27 at 09:46 -0700, Bart Van Assche wrote:
> On Wed, 2019-03-27 at 12:11 -0400, Martin K. Petersen wrote:
> > Commit a83da8a4509d ("scsi: sd: Optimal I/O size should be a
> > multiple
> > of physical block size") split one conditional into several
> > separate
> > statements in an effort to provide more accurate warning messages
> > when
> > a device reports a nonsensical value. However, this reorganization
> > accidentally dropped the precondition of the reported value being
> > larger than zero. This lead to a warning getting emitted on devices
> > that do not report an optimal I/O size at all.
> >
> > Remain silent if a device does not report an optimal I/O size.
> >
> > Fixes: a83da8a4509d ("scsi: sd: Optimal I/O size should be a
> > multiple of physical block size")
> > Reported-by: Hussam Al-Tayeb <ht990332@gmx.com>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>
>

I tested two SATA disks and three usb flash drives on two machines. The
warnings are gone.
Thank you very much for the patch.
