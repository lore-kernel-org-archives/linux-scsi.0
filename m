From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] remove dead ATAPI multi-lun support (used for ide-scsi)
Date: Sun, 7 Mar 2004 11:53:44 -0500
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20040307165344.GM29509@serve.riede.org>
References: <200402202247.02345.bzolnier@elka.pw.edu.pl> <20040307134905.GK29509@serve.riede.org> <404B4A1D.80107@pobox.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <404B4A1D.80107@pobox.com> (from jgarzik@pobox.com on Sun, Mar 07, 2004 at 11:13:17 -0500)
To: Jeff Garzik <jgarzik@pobox.com>
Cc: wrlk@riede.org, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2004.03.07 11:13, Jeff Garzik wrote:
> Willem Riede wrote:
> >
> > I have verified that this works with my PD/CD drive, the patch to ide-scsi.c
> > that I suggest (against linux-2.6.4-rc1-mm2) is below.
> 
> 
> I have a multi-LUN ATAPI CD changer here...

If you can test my patch with it, that would be great. 
My CD changer doesn't report multiple LUNs :-(

Thanks, Willem Riede.
