From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 7 of 9] scsi_debug: Add support for physical block exponent
 and	alignment
Date: Fri, 24 Apr 2009 02:10:00 -0400
Message-ID: <49F157B8.4000507@interlog.com>
References: <patchbomb.1240551141@sermon.lab.mkp.net> <7ec2d82b188a9e9d4c56.1240551148@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <7ec2d82b188a9e9d4c56.1240551148@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> This patch adds support for setting the physical block exponent and
> lowest aligned LBA in the READ CAPACITY(16) response.
> 
> The B0 VPD page is adjusted accordingly.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Sorry, not much of a flame.

BTW Does scsi_debug identify itself (in VPD b1h) as a SSD?
