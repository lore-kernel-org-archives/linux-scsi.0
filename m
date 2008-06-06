From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch -v3 22/22] qla2xxx: use memory_read_from_buffer
Date: Fri, 6 Jun 2008 10:06:53 -0700
Message-ID: <20080606170653.GC388@plap4-2.local>
References: <20080604115633.116832712@gmail.com> <20080604115859.351267641@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762247AbYFFRHJ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080604115859.351267641@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Andrew Vasquez <linux-driver@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 04 Jun 2008, Akinobu Mita wrote:

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andrew Vasquez <linux-driver@qlogic.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |   45 ++++++++--------------------------------
>  1 file changed, 10 insertions(+), 35 deletions(-)

Basic testing looks good.  Thanks.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
