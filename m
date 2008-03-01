From: Gerold Jury <gml@inode.at>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Sat, 1 Mar 2008 13:29:11 +0100
Message-ID: <200803011329.11315.gml@inode.at>
References: <200802252005.22663.gml@inode.at> <200802292259.12047.gml@inode.at> <20080301145354.ca4d4f1a.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080301145354.ca4d4f1a.vsu@altlinux.ru>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Yes it happens with the DVD+RW (testet with dd now) and with DVD+R

Thank you for the byte interpretation.
Now I have a hint where to start with the debugging.

Regards
Gerold

On Saturday 01 March 2008 12:53:54 Sergey Vlasov wrote:
>
>0x2a is the SCSI WRITE(10) command; the following 10 bytes look like
>its arguments (bytes 2-5 - logical block address, bytes 7-8 - transfer
>length in blocks); last 4 bytes seem to be another copy of the logical
>block address.
>
>
>Does this happen only with DVD-RAM?  Could you try with a DVD+RW disk
>(these disks could also be written to with a simple "dd" after initial
>formatting)?
>
