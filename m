From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 7 Jan 2003 10:21:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107102127.B15528@beaverton.ibm.com>
References: <3E1ADC9A.6090800@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E1ADC9A.6090800@splentec.com>; from luben@splentec.com on Tue, Jan 07, 2003 at 08:56:42AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 08:56:42AM -0500, Luben Tuikov wrote:
> The three incremental patches which I posted got mutilated
> when pasted into Mozilla from the X clipboard buffer.
> (TAB char got 2 spaces.)
> 
> The patches are also available, in pristine form, here:
> http://www.splentec.com/~luben/patches.html

For use with multi-path, it is very useful to have the path in the
scsi_cmnd, and generally to not have the lldd's know about the scsi_device
at all, such that we can pick a path, and send a scsi_cmnd to a lldd.

Putting path information only in scsi_device makes it hard to do
multi-path below (or even in) the block layer, and makes it hard to
multi-path non block devices (like tape).

I would prefer we keep the current scsi_cmnd with its
host/channel/target[id]/lun.

-- Patrick Mansfield
