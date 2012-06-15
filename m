From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 15 Jun 2012 10:22:11 -0400 (EDT)
Message-ID: <b20e68ee-0e3c-4a44-86e4-734c6205cbbe@zmail13.collab.prod.int.phx2.redhat.com>
References: <20120615135825.GA12847@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120615135825.GA12847@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

> This should be -stable material as well, as >=3.2.y kernel versions
> are affected (I think 3.0.y is OK?).

Not sure, but -ENOIOCTLCMD needed to be changed to -ENOTTY on some
kernel versions (but the conflicts will make this pretty evident).

Paolo
