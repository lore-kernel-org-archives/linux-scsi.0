From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 00:11:40 +0300
Message-ID: <20090729211140.GB3592@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753886AbZG2VMo@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1248875763.3900.1.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
>      3. Take over include/scsi export from glibc: this will necessitate
>         comparing our current headers and those of glibc and moving
>         stuff around.

Speaking of which: is there a chance some userspace still depends on
SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} being defined (even though they don't
work) ? glibc headers have them ...
