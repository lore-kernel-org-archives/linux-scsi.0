From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mpt3sas: downgrade full copy_from_user to access_ok check
Date: Wed, 20 Sep 2017 08:04:00 -0700
Message-ID: <20170920150400.GA18201@infradead.org>
References: <1505877071-76996-1-git-send-email-mengxu.gatech@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505877071-76996-1-git-send-email-mengxu.gatech@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Meng Xu <mengxu.gatech@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, meng.xu@gatech.edu, sanidhya@gatech.edu, taesoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 11:11:11PM -0400, Meng Xu wrote:
> Since right after the user copy, we are going to
> memset(&karg, 0, sizeof(karg)), I guess an access_ok check is enough?

The right thing is to remove it entirely.
